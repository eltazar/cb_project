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
#import "Reachability.h"

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
    
    footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reverse_nav_bar"]];

    webView.delegate = self;
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    //rimuove ombra dietro la pagina web
    for(UIView *wview in [[[webView subviews] objectAtIndex:0] subviews]) {
        if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
    }
    
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];
    
    spinner = [[CustomSpinnerView alloc] initWithFrame:self.view.frame];
    spinner.frame = CGRectMake(self.navigationController.navigationBar.frame.size.width/2 - spinner.frame.size.width/2, self.view.frame.size.height/2 - spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
    
    _callButton.enabled = NO;
    _mailButton.enabled = NO;
    
    //flurry log
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.title, @"Titolo_documento",
     nil];
    [Utilities logEvent:@"Documento_letto" arguments:articleParams];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    [self fetchData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    if(errorView && errorView.showed){
        [errorView removeFromSuperview];
    }
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
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"FALLITO DOWNLOAD PDF = %@", [error localizedDescription]);
}

#pragma mark - WMHTTPAccessDelegate

-(void)didReceiveJSON:(NSArray *)jsonArray{
    NSLog(@"JSON DESC : %@",[[jsonArray objectAtIndex:0] objectForKey:@"testo"]);
    
    [self stopSpinner];
    mail = [[jsonArray objectAtIndex:0] objectForKey:@"email"];
    phone = [[jsonArray objectAtIndex:0] objectForKey:@"telefono"];    
    _callButton.enabled = YES;
    _mailButton.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;

}

-(void)didReceiveError:(NSError *)error{
    //NSLog(@"Error json = %@",error.description);
    [self showErrorView:@"Errore server"];
    _callButton.enabled = NO;
    _mailButton.enabled = NO;
    [self stopSpinner];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}
-(void)fetchData{
    if([Utilities networkReachable]){
        [PDHTTPAccess getDocumentContents:[idPag intValue] delegate:self];
        [spinner startAnimating];
        [self.view addSubview:spinner];
    }
    else{
        [self showErrorView:@"Connessione assente"];
    }
}

-(void)stopSpinner{
    [spinner stopAnimating];
    [spinner removeFromSuperview];
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
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:@"E-mail",@"Stampa",nil,nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    } else {
        [actionSheet showInView:self.view];
    }
}

-(IBAction) writeEmail{
    [Utilities sendEmail:mail controller:self delegate:self];
}

-(IBAction)callNumber{
}

#pragma mark - MFMailComposeViewControllerDelegate


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissModalViewControllerAnimated:YES];
    if(result == MFMailComposeResultSent) {
        NSLog(@"messaggio inviato");
        [Utilities logEvent:@"Documento_spedito" arguments:[NSDictionary dictionaryWithObjectsAndKeys:self.title,@"Titolo_documento",nil]];
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
        //condivisione con mail
        [Utilities sendEmail:nil object:self.title content:htmlPage html:YES controller:self delegate:self];
    }
    if(buttonIndex == 1){
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
    
    [Utilities logEvent:@"Documento_stampato" arguments:[NSDictionary dictionaryWithObjectsAndKeys:self.title,@"Titolo_documento",nil]];
}

#pragma mark - ErrorView methods
-(void)showErrorView:(NSString*)message{
    
    errorView.label.text = message;
    [errorView.tapRecognizer addTarget:self action:@selector(hideErrorView:)];
    
    CGRect oldFrame = [errorView frame];
    [errorView setFrame:CGRectMake(0, 43, oldFrame.size.width, 0)];
    
    [self.navigationController.view addSubview:errorView];
    
    [UIView animateWithDuration:0.5
                     animations:^(void){
                         [errorView setFrame:CGRectMake(0, 43, oldFrame.size.width, oldFrame.size.height)];
                     }
     ];
    errorView.showed = YES;
}

-(void)hideErrorView:(UITapGestureRecognizer*)gesture{
    
    if(errorView || errorView.showed){
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             [errorView setFrame:CGRectMake(0, 43, errorView.frame.size.width,0)];
                         }
                         completion:^(BOOL finished){
                             //riprovo query quando faccio tap su riprova
                             [self fetchData];
                         }
         ];
        errorView.showed = NO;
    }
}

#pragma mark - Recheability

- (void) networkStatusChanged:(NSNotification*) notification
{
	Reachability* reachability = notification.object;
    NSLog(@"*** AreaBaseController: network status changed ***");
	if(reachability.currentReachabilityStatus == NotReachable){
		NSLog(@"Internet off");
        [self showErrorView:@"Connessione assente"];
    }
	else{
		NSLog(@"Internet on");
        [self hideErrorView:nil];
    }
}


@end
