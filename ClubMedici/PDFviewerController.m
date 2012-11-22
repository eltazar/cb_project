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
@synthesize webView, navBar,actionButton,tabBar;

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
    
//    tabBar.frame = CGRectMake(0,0, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//    [self.webView addSubview:self.tabBar];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.webView addGestureRecognizer:tapRec];
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

-(void)didTap:(id)sender{
    
    
    [UIView animateWithDuration:0.4
                     animations:^void{
                         self.tabBar.alpha = 1.0;
                     }
    ];
    //NSTimer *timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(hideTabBar:) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(hideTabBar:)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)hideTabBar:(id)sender{
    [UIView animateWithDuration:0.4
                     animations:^void{
                         self.tabBar.alpha = 0.0;
                     }
     ];
}

-(IBAction)doneButtonPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)actionButtonPressed:(id)sender{
   
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Stampa",nil,nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [actionSheet showFromBarButtonItem:self.actionButton animated:YES];
    } else {
        [actionSheet showInView:self.view];
    }    
}

-(IBAction)openIn:(id)sender
{
    //use the UIDocInteractionController API to get list of devices that support the file type
    
    UIDocumentInteractionController *docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:@"http://www.clubmedici.it/nuovo/download/finanziario/leasing/leasing.pdf"]];
    
    //present a drop down list of the apps that support the file type, click an item in the list will open that app while passing in the file.
    [docController presentOpenInMenuFromRect:CGRectMake(0, 0, 300, 300) inView:self.view animated:YES];
}
#pragma mark - ActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"INDEX = %d",buttonIndex);
    
    if(buttonIndex == 0){
        //stampa
        [self printWebView:self];
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
