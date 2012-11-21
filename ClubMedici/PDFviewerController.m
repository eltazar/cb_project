//
//  PDFviewerWebViewViewController.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "PDFviewerController.h"

@interface PDFviewerController ()

@end

@implementation PDFviewerController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    NSURL *targetURL = [NSURL URLWithString:@"http://www.clubmedici.it/nuovo/download/finanziario/leasing/leasing.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];
    
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

@end
