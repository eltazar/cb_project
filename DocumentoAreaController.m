//
//  DescrizioneAreaController.m
//  ClubMedici
//
//  Created by mario on 23/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "DocumentoAreaController.h"
#import "PDHTTPAccess.h"

@interface DocumentoAreaController ()

@end

@implementation DocumentoAreaController
@synthesize webView,idPag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) init{
    
    self = [self initWithNibName:@"DocumentoAreaController" bundle:nil];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
//    NSString* url = @"http://www.clubmedici.it/app/iphone/DescrizioneDocumento.php?idPagina=2";
//    
//    NSURL* nsUrl = [NSURL URLWithString:url];
//    
//    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
//    
//    [webView loadRequest:request];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [PDHTTPAccess getDocumentContents:[idPag intValue] delegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WMHTTPAccessDelegate

-(void)didReceiveJSON:(NSArray *)jsonArray{
    NSLog(@"JSON DESC : %@",jsonArray);
    NSString *htmlString = [[jsonArray objectAtIndex:0] objectForKey:@"testo"];
    [webView loadHTMLString:htmlString baseURL:nil];
    
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"Error json = %@",error.description);
}

@end
