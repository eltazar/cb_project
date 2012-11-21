//
//  PDFviewerWebViewViewController.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "PDFviewerController.h"

@interface PDFviewerController ()
{
    NSString *title;
    NSString *url;
}
@end

@implementation PDFviewerController
@synthesize webView, navBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTitle:(NSString*)aTitle url:(NSString*)aUrl
{
    self = [super initWithNibName:@"PDFviewerController" bundle:nil];
    if (self) {
        // Custom initialization
        title = aTitle;
        url = aUrl;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    NSURL *targetURL = [NSURL URLWithString:@"http://www.clubmedici.it/nuovo/download/finanziario/leasing/leasing.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [self.webView loadRequest:request];
    
    navBar.topItem.title = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"INIZIATO DOWNLOAD PDF");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"Finito DOWNLOAD PDF");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"FALLITO DOWNLOAD PDF = %@", [error localizedDescription]);
}


#pragma mark - Button methods 
-(IBAction)doneButtonPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
@end
