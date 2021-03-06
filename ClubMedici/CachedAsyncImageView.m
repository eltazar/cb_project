//
//  CachedAsyncImageView.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 10/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CachedAsyncImageView.h"


/****************************************************/
@interface ImageCache : NSObject {
@private
    NSMutableDictionary *_cache;
}
+ (ImageCache *)sharedInstance;
- (UIImage *)imageForURLString:(NSString *)urlString;
- (void)setImage:(UIImage *)image forURLString:(NSString *)urlString;
- (void)emptyCache;
@end
/***************************************************/


@interface CachedAsyncImageView ()
- (void)initialize;
- (void)releaseConnection;
@end



@implementation CachedAsyncImageView
@synthesize delegate;

- (id)init {
    //NSLog(@"[%@]::init", [self class]);
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)awakeFromNib {
    //NSLog(@"[%@]::awakeFromNib", [self class]);
    [super awakeFromNib];
    [self initialize];
}


- (void)dealloc {
    [self releaseConnection];
}


# pragma mark - NSURLConnectionDelegate


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    @synchronized (self) {
        if (connection != _connection) return;
        _receivedData = [[NSMutableData alloc] initWithCapacity:40000];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    @synchronized (self) {
        if (connection != _connection) return;
        [_receivedData appendData:data];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Settare un immagine placeholder?
    @synchronized (self) {
        if (connection != _connection) return;
        [_activityIndicator stopAnimating];
        [self releaseConnection];
    }
    
    if(delegate && [delegate respondsToSelector:@selector(didErrorLoadingImage:)])
        [delegate didErrorLoadingImage:self];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"[%@ didFinishLoading]: - loaded %d bytes", [self class], _receivedData.length);
    UIImage *image;
    NSString *string;
    @synchronized (self) {
        if (connection != _connection) return;
        string =[[NSString alloc] initWithBytes:[_receivedData mutableBytes] length:[_receivedData length]encoding:NSUTF8StringEncoding]; 
        if ([string isEqualToString:@"Use a placeholder"]) {
            image = [UIImage imageNamed:@"icon.png"];
        }
        else {
            image = [UIImage imageWithData:_receivedData];
        }
        [[ImageCache sharedInstance] setImage:image forURLString:_urlString];
        [self releaseConnection];
    }
    [_activityIndicator stopAnimating];
    
    self.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    self.image = image;
    self.alpha = 1;
    [UIView commitAnimations];
    
    if(delegate && [delegate respondsToSelector:@selector(didFinishLoadingImage:)])
       [delegate didFinishLoadingImage:self];
}


# pragma mark - CachedAsyncImageView


- (void)loadImageFromURL:(NSURL *)url {
    @synchronized (self) {
        if (_connection) {
            [self releaseConnection];
        }
        
        _urlString = url.absoluteString;
        //NSLog(@"[%@ loadImageFromUrl]  [[%@]+]", [self class], [_urlString substringWithRange:NSMakeRange(_urlString.length-1-10, 3)]);
        UIImage *image = [[ImageCache sharedInstance] imageForURLString:_urlString];
        //NSLog(@"[%@ loadImageFromURL]: _urlString = %@", [self class], _urlString);
        if (image) {
            //NSLog(@"                          \t Cache Hit! [[%@]-]", [_urlString substringWithRange:NSMakeRange(_urlString.length-1-10, 3)]);
            self.image = image;
            _urlString = nil;
            if(delegate && [delegate respondsToSelector:@selector(didFinishLoadingImage:)])
                [delegate didFinishLoadingImage:self];
        }
        else {
            //self.image = nil;
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            if (_connection) {
                [_activityIndicator startAnimating];
            }
            else {
                [self connection:nil didFailWithError:nil];
            }
        }
    }
}


- (void)loadImageFromURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    [self loadImageFromURL:url];
}


- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
    _activityIndicator.activityIndicatorViewStyle = style;
}


+ (void)emptyCache {
    [[ImageCache sharedInstance] emptyCache];
}

- (void)setCustomPlaceholder:(NSString*)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    self.image = image;
}

# pragma mark - CachedAsyncImageView (metodi privati)


- (void)initialize {
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    _activityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:_activityIndicator];
    _activityIndicator.hidden = YES;
}


- (void)releaseConnection {
    @synchronized (self) {
        _urlString = nil;
        [_connection cancel];
        _connection = nil;
        _receivedData = nil;
    }
}

@end





/****************************************************/
@implementation ImageCache
static ImageCache *__sharedInstance;

+ (id)alloc {
    NSAssert(__sharedInstance == nil, @"Attempted to allocate a second instance of a singleton."); 
    __sharedInstance = [super alloc];
    return __sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _cache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (ImageCache *)sharedInstance {
    if (!__sharedInstance) {
        __sharedInstance = [[ImageCache alloc] init];
    }
    return __sharedInstance;
}

- (UIImage *)imageForURLString:(NSString *)urlString {
    @synchronized (_cache) {
        return [_cache objectForKey:urlString];
    }
}

- (void)setImage:(UIImage *)image forURLString :(NSString *)urlString {
    @synchronized (_cache) {
        if (!image) {
            //nslog(@"Attempt to put nil image in cache (key: %@)", urlString);
            return;
        }
        [_cache setObject:image forKey:urlString];
    }
}

- (void)emptyCache {
    @synchronized (_cache) {
        //NSLog(@"[%@]::emptyCache", [self class]);
        [_cache removeAllObjects];
    }
}
@end
