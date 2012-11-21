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
@synthesize webView, navBar,actionButton;

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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
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
-(IBAction)actionButtonPressed:(id)sender{
   
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil otherButtonTitles:@"Stampa",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [actionSheet showFromBarButtonItem:self.actionButton animated:YES];
    } else {
        [actionSheet showInView:self.view];
    }


    
}

#pragma mark - ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        //stampa
        [self printWebView:self];
    }
    else if(buttonIndex == 1){
        //cancel
    }
}
#pragma mark - AirPrint

- (void)printWebView:(id)sender {
    
    UIPrintInteractionController *pc = [UIPrintInteractionController sharedPrintController];
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = title;
    pc.printInfo = printInfo;
    
    //pc.showsPageRange = YES;
    
    UIViewPrintFormatter *formatter = [self.webView viewPrintFormatter];
    pc.printFormatter = formatter;
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            NSLog(@"Print failed - domain: %@ error code %u", error.domain, error.code);
        }
    };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [pc presentFromBarButtonItem:self.actionButton animated:YES completionHandler:completionHandler];
    } else {
        [pc presentAnimated:YES completionHandler:completionHandler];
    }
}


@end
