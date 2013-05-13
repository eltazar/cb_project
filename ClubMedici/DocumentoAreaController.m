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
#import "AreaTurismoItem.h"
#import "SharingProvider.h"

@interface DocumentoAreaController (){
    SharingProvider *_sharingProvider;

}
@end

@implementation DocumentoAreaController
@synthesize webView, docItem, turismoItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sharingProvider = [SharingProvider sharedInstance];
    
    if(docItem){
        self.title = [docItem objectForKey:@"LABEL"];
        // Custom initialization
        _sharingProvider.isSocial = NO;
        //flurry log
        [Utilities logEvent:@"Documento_letto" arguments:[NSDictionary dictionaryWithObjectsAndKeys:self.title,@"Titolo_documento", nil]];
        
    }
    if(turismoItem){
        self.title = turismoItem.title;
        phone = turismoItem.phone;
        mail = turismoItem.email;
        // Custom initialization
        _sharingProvider.isSocial = YES;
        _sharingProvider.viewController = self;
        //flurry log
        [Utilities logEvent:@"Pdf_vacanze_letto" arguments:[NSDictionary dictionaryWithObjectsAndKeys:self.title,@"Titolo_pdf_vacanze",nil]];
        webView.scalesPageToFit=YES; 
    }
    _sharingProvider.viewController = self;
    
    footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reverse_nav_bar"]];

    webView.delegate = self;
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    //rimuove ombra dietro la pagina web
    for(UIView *wview in [[[webView subviews] objectAtIndex:0] subviews]) {
        if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0f green:244/255.0f blue:245/255.0f alpha:1];
    
    spinner = [[CustomSpinnerView alloc] initWithFrame:self.view.frame];
    spinner.frame = CGRectMake(self.navigationController.navigationBar.frame.size.width/2 - spinner.frame.size.width/2, self.view.frame.size.height/2 - spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
    
    _callButton.enabled = NO;
    _mailButton.enabled = NO;
    

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
    [self.webView stopLoading];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"INIZIATO DOWNLOAD PDF");
    [self startSpinner];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finito DOWNLOAD PDF");
    [self stopSpinner];
    [self enableButtonsView:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"FALLITO DOWNLOAD PDF = %@", [error localizedDescription]);
    [self stopSpinner];
    [self enableButtonsView:NO];
}

#pragma mark - WMHTTPAccessDelegate

-(void)didReceiveJSON:(NSArray *)jsonArray{
    NSLog(@"JSON DESC : %@",[[jsonArray objectAtIndex:0] objectForKey:@"testo"]);
    
    [self stopSpinner];
    [self enableButtonsView:YES];

    mail = [[jsonArray objectAtIndex:0] objectForKey:@"email"];
    phone = [[jsonArray objectAtIndex:0] objectForKey:@"telefono"];    
}

-(void)didReceiveError:(NSError *)error{
    //NSLog(@"Error json = %@",error.description);
    [self showErrorView:@"Errore server"];

    [self stopSpinner];
    [self enableButtonsView:NO];
}
-(void)fetchData{
    if([Utilities networkReachable]){
        
        if(docItem){
            [PDHTTPAccess getDocumentContents:[[docItem objectForKey:@"ID_PAG"] intValue] delegate:self];
            [self startSpinner];
        }
        if(turismoItem){
            NSString *encodedString=[turismoItem.pdfUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *weburl = [NSURL URLWithString:encodedString];
            NSURLRequest *request = [NSURLRequest requestWithURL:weburl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
            [self.webView loadRequest:request];
        }
    }
    else{
        [self showErrorView:@"Connessione assente"];
    }
}

#pragma mark - Error&Spinner handler

-(void)startSpinner{
    [spinner startAnimating];
    [self.view addSubview:spinner];
}

-(void)stopSpinner{
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}

-(void)enableButtonsView:(BOOL)enable{
    self.navigationItem.rightBarButtonItem.enabled = enable;
    _callButton.enabled = enable;
    _mailButton.enabled = enable;
}

-(IBAction) writeEmail{
    [Utilities sendEmail:mail controller:self delegate:[SharingProvider sharedInstance]];
}

-(IBAction)callNumber{
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


#pragma mark - Private methdos
- (void)actionButtonPressed:(id)sender {
    if(turismoItem){
        _sharingProvider.iOS6String  = [NSString stringWithFormat:
                                        @"Offerta Turismo ClubMedici: %@\n %@",
                                        self.turismoItem.title,
                                        self.turismoItem.pdfUrl];
        
        _sharingProvider.mailObject  = [NSString stringWithFormat:
                                        @"Offerta Turismo ClubMedici: %@",
                                        self.turismoItem.title];
        
        _sharingProvider.mailBody    = [NSString stringWithFormat:
                                        @"Ciao, leggi l'offerta turismo di ClubMedici:\n%@",
                                        self.turismoItem.pdfUrl];
        
        _sharingProvider.initialText = [NSString stringWithFormat:
                                        @"Offerta Turismo ClubMedici: %@",
                                        self.turismoItem.title];
        
        _sharingProvider.url         = [NSString stringWithFormat:@"%@",
                                        self.turismoItem.pdfUrl];
        
        _sharingProvider.title       = self.turismoItem.title;
        
        _sharingProvider.image       = self.turismoItem.imageUrl;

        NSLog(@"imageUrl: %@", self.turismoItem.imageUrl);
    }
    
    if(docItem){
        _sharingProvider.iOS6String = htmlPage;
        _sharingProvider.mailObject  =  [docItem objectForKey:@"LABEL"];
        
        _sharingProvider.mailBody    = htmlPage;
    }
    _sharingProvider.printView = [self.webView viewPrintFormatter];

    [_sharingProvider sharingAction:sender];
}

#pragma mark - AirPrint


- (void)printWebView:(id)sender {
    UIPrintInteractionController *pc = [UIPrintInteractionController sharedPrintController];
    pc.delegate = self;
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = self.navigationController.title;
    pc.printInfo = printInfo;
    
    //pc.showsPageRange = YES;
    pc.printFormatter = [self.webView viewPrintFormatter];
    
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

@end
