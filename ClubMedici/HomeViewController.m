//
//  ViewController.m
//  ClubMedici
//
//  Created by mario greco on 17/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "SharingProvider.h"
#import "Reachability.h"
#import "Utilities.h"
#import <AudioToolbox/AudioToolbox.h>


@interface HomeViewController () {
    NSArray *json;
    SharingProvider *_sharingProvider;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reverse_nav_bar"]];

    self.title = @"News";
    
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setOpaque:NO];
    webView.delegate = self;
    webView.tag = 999;
    
    //rimuove ombra dietro la pagina web
    for(UIView *wview in [[[webView subviews] objectAtIndex:0] subviews]) {
        if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
    }
    
    shareButton.enabled = NO;
    
    spinner = [[CustomSpinnerView alloc] initWithFrame:self.view.frame];
    spinner.frame = CGRectMake(self.navigationController.navigationBar.frame.size.width/2 - spinner.frame.size.width/2, self.view.frame.size.height/2 - spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
    _sharingProvider = [[SharingProvider alloc] init];
    _sharingProvider.viewController = self;
    
    for (UIView* subView in webView.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            currentScrollView = (UIScrollView *)subView;
            currentScrollView.delegate = (id) self;
        }
    }
    
    //[currentScrollView addSubview:titleLabel];

    
    // Set up Pull to Refresh code
    PullToRefreshView *pull = [[PullToRefreshView alloc] initWithScrollView:currentScrollView];
    [pull setDelegate:self];
    pull.tag = 998;
    [currentScrollView addSubview:pull];
}

-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    //[(UIWebView *)[self.view viewWithTag:999] reload];
    //NSLog(@"RICARICATO");
    [self fetchData];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv
{
    //[(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
}

- (IBAction)sendPost:(id)sender {

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    // Register for notifications on FB session state changes
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    [self fetchData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSessionStateChangedNotification object:nil];
    if(errorView && errorView.showed){
        [errorView removeFromSuperview];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)  interfaceOrientation duration:(NSTimeInterval)duration{
    
    NSLog(@"ROTAZIONE");
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return;
    
    spinner.frame = CGRectMake(self.navigationController.navigationBar.frame.size.width/2 - spinner.frame.size.width/2, self.view.frame.size.height/2 - spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FetchData & network


- (void)fetchData {
    if([Utilities networkReachable]){
        [spinner startAnimating];
        [self.view addSubview:spinner];
        [PDHTTPAccess getNews:1 delegate:self];
    }
    else{
        [self showErrorView:@"Connessione assente"];
    }
}


- (void)showErrorView:(NSString*)message {
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


- (void)hideErrorView:(UITapGestureRecognizer*)gesture {
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


//lasciare vuoto per levare effetto shadow nel  container
- (void)styleContainer:(UIView *)container animate:(BOOL)animate duration:(NSTimeInterval)duration {
    
}


- (void) networkStatusChanged:(NSNotification*) notification {
	Reachability* reachability = notification.object;
    NSLog(@"*** HomeViewController: network status changed ***");
	if(reachability.currentReachabilityStatus == NotReachable){
		NSLog(@"Internet off");
        [self showErrorView:@"Connessione assente"];
    }
	else{
		NSLog(@"Internet on");
        [self hideErrorView:nil];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"INIZIATO DOWNLOAD PDF");
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"FALLITO DOWNLOAD PDF = %@", [error localizedDescription]);

}



#pragma mark - WMHTTPAccessDelegate



-(void)didReceiveJSON:(NSArray *)jsonArray{
    NSLog(@"JSON = %@",jsonArray);
    [(PullToRefreshView *)[self.view viewWithTag:998] finishedLoading];
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    shareButton.enabled = YES;
    json = jsonArray;
    NSString *title = [[jsonArray objectAtIndex:0]objectForKey:@"titolo"];
    [Utilities logEvent:@"News_letta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:title,@"Titolo_news",nil]];
}


-(void)didReceiveError:(NSError *)error{
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    NSLog(@"Server error = %@",error.description);
    [self showErrorView:@"Errore server"];
    shareButton.enabled = NO;
}


- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}



#pragma mark - FacebookSessionState



- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        NSLog(@"LOGGATO");
        
        //appena loggato mostro pulsante logout, e lancio finestra per scrivere il post
        UIImage *buttonImage = [UIImage imageNamed:@"fbLogout"];
        UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tmpButton setImage:buttonImage forState:UIControlStateNormal];
        tmpButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
        [tmpButton addTarget:self action:@selector(logoutFromFB:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *logoutBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpButton];
        self.navigationItem.rightBarButtonItem = logoutBtn;
    } else {
        NSLog(@"SLOGGATO");
        self.navigationItem.rightBarButtonItem = nil;
    }
}


-(void)logoutFromFB:(id)sender{
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    [appDelegate closeSession];
}




#pragma mark - IBActions



- (IBAction)sharingAction:(id)sender {
    NSDictionary *item = [json objectAtIndex:0];
    NSString *titolo   = [item objectForKey:@"titolo"];
    NSString *idString = [item objectForKey:@"id"];
    
    _sharingProvider.iOS6String  = [NSString stringWithFormat:@"News ClubMedici: %@\n %@%@",
                                    titolo,
                                    URL_NEWS,
                                    idString];
    
    _sharingProvider.mailObject  = [NSString stringWithFormat:@"News ClubMedici: \n%@",
                                    titolo];
    
    _sharingProvider.mailBody    = [NSString stringWithFormat:
                                    @"Ciao leggi la nuova news di ClubMedici:\n%@%@",
                                    URL_NEWS,
                                    idString];
    
    _sharingProvider.initialText = [NSString stringWithFormat:@"News ClubMedici: \n%@",
                                    titolo];
    
    _sharingProvider.url         = [NSString stringWithFormat:@"%@%@",
                                    URL_NEWS,
                                    idString];
    
    _sharingProvider.title       = titolo;
    
    _sharingProvider.image       = [NSString stringWithFormat:
                                    @"http://www.clubmedici.it/nuovo/%@",
                                    [item objectForKey:@"foto"]];
    
    [_sharingProvider sharingAction:sender];    
}


@end
