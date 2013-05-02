//
//  DocumentoAreaController.m
//  ClubMedici
//
//  Created by mario on 30/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "DocumentoAreaController.h"
#import "PDHTTPAccess.h"
#import "Utilities.h"

@interface DocumentoAreaController (){
    UIActionSheet *actionSheet;
}
@end

@implementation DocumentoAreaController
@synthesize webView, idPag;

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
    webView.delegate = self;
    
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"INIZIATO DOWNLOAD PDF");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finito DOWNLOAD PDF");
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"FALLITO DOWNLOAD PDF = %@", [error localizedDescription]);
}

#pragma mark - WMHTTPAccessDelegate

-(void)didReceiveJSON:(NSArray *)jsonArray{
    NSLog(@"JSON DESC : %@",[[jsonArray objectAtIndex:0] objectForKey:@"testo"]);
    NSString *htmlString = [[jsonArray objectAtIndex:0] objectForKey:@"testo"];
    mail = [[jsonArray objectAtIndex:0] objectForKey:@"email"];
    phone = [[jsonArray objectAtIndex:0] objectForKey:@"telefono"];
    //[webView loadHTMLString:htmlString baseURL:nil];
    
    // add a generic template and the css file directive
//    NSString* htmlPage = @"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"> <html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"he\" lang=\"he\"><head><style type=\"text/css\" media=\"all\">@import \"documentoCSS.css\";</style><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /></head><body>%@</body></html>";
   /* NSString *prova = @"<html>    <head>    <title>Esempio</title>    <style type=\"text/css\">    body {background-color: #FF0000;}    </style>    </head>    <body>    <p>Questa è una pagina rossa</p>    </body>	</html>";*/
    
    // load the html into a web view
    //NSURL *url = [NSURL fileURLWithPath:fullPath];
    
    NSString *htmlPage = @"<html><head><style type=\"text/css\">%@</style></head>    <body>%@</body></html>";
    NSString *style = @"body {margin:15px 15px 15px 15px;background-color: #f6faff;}body,p,strong {font:Helvetica;text-align: justify;font-size: 17px;color: #333333;text-shadow: #fff 0px 1px 0px;}";//font-size: 16px;text-align: justify;color: #272727;text-shadow: 1px 4px 6px #f6faff, 0 0 0 #000, 1px 4px 6px #f6faff;}";//
    htmlPage = [NSString stringWithFormat:htmlPage,style,htmlString];
    [webView loadHTMLString:htmlPage baseURL:nil];
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"Error json = %@",error.description);
    [self showErrorView:@"Errore server"];
}
-(void)fetchData{
    if([Utilities networkReachable]){
        [PDHTTPAccess getDocumentContents:[idPag intValue] delegate:self];
    }
    else{
        [self showErrorView:@"Connessione assente"];
    }
}


#pragma mark - UIButton methods

- (void)actionButtonPressed:(id)sender {
    
    NSString *cancelButtonTitle = @"Annulla";
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cancelButtonTitle = nil;
    }
    
    if ([actionSheet isVisible]) {
        //[actionSheet dismissWithClickedButtonIndex:-1 animated:NO];
    }
    else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:@"Stampa",nil,nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    } else {
        [actionSheet showInView:self.view];
    }
}

-(IBAction) writeEmail{
    [Utilities sendEmail:mail controller:self];
}

-(IBAction)callNumber{
    [Utilities callNumber:phone];
}

#pragma mark - MFMailComposeViewControllerDelegate


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissModalViewControllerAnimated:YES];
    if(result == MFMailComposeResultSent) {
        NSLog(@"messaggio inviato");
    }
	else if (result == MFMailComposeResultFailed){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messaggio non inviato!" message:@"Non è stato possibile inviare la tua e-mail" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil];
		[alert show];
	}
    else if (result == MFMailComposeResultCancelled){
        NSLog(@"messaggio annullato");
    }
}

#pragma mark - ActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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
    printInfo.jobName = self.navigationController.title;
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
        [pc presentFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES completionHandler:completionHandler];
    } else {
        [pc presentAnimated:YES completionHandler:completionHandler];
    }
}

@end
