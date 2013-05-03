//
//  ErrorView.m
//  ClubMedici
//
//  Created by mario on 28/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "ErrorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ErrorView
@synthesize label, tapRecognizer, showed;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithSize:(CGSize)size{
    self = [super init];
    if(self){
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ErrorView_iPad"
                                                          owner:self
                                                        options:nil];
        UIView *v = [nibViews objectAtIndex:0];
        [label setAutoresizingMask:
         UIViewAutoresizingFlexibleWidth];
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:
         UIViewAutoresizingFlexibleWidth];
        [v setAutoresizesSubviews:YES];
        [v setAutoresizingMask:
         UIViewAutoresizingFlexibleWidth];
        [self setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y,size.width, 38)];

        [self configureLayers];
        [self addSubview:v];
        self.tapRecognizer = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapRecognizer];
    }
    return self;
}

-(id)init{
    
    //fondamentale settare il frame per far si che venga riconoscitua una gesture su questa view
    //http://stackoverflow.com/q/5485216

    self = [super init];

    if(self){
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ErrorView"
                                                          owner:self
                                                        options:nil];
                
        UIView *v = [nibViews objectAtIndex:0];
        
        [self setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y, v.frame.size.width, v.frame.size.height)];
        
        [self configureLayers];
        [self addSubview:v];
        self.tapRecognizer = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapRecognizer];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    if(self.subviews && self.subviews.count > 0){
        //dato che self ha clipToBounds e maskToBounds = NO, devo dire alle subview di fare il resize
        UIView *subView = [self.subviews objectAtIndex:0];
        [subView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    }
}

-(void)configureLayers{
    //self.clipsToBounds = YES;
    self.layer.masksToBounds = NO;
    [self.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.layer setBorderWidth:0.6f];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.8];
    [self.layer setShadowRadius:3.0];
    [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

@end
