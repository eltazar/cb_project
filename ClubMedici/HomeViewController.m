//
//  ViewController.m
//  ClubMedici
//
//  Created by mario greco on 17/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "Reachability.h"

@interface HomeViewController ()
{
    NSArray *json;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1/255.0f green:70/255.0f blue:148/255.0f alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];
    
    self.title = @"ClubMedici";
    //il controller figlio di questo controller avrà il titolo del back Button personalizzato
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

-(void)viewWillAppear:(BOOL)animated{
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSessionStateChangedNotification object:nil];
    if(errorView && errorView.showed){
        [errorView removeFromSuperview];
    }
}

-(void)fetchData{
    if([Utilities networkReachable]){
        [PDHTTPAccess getNews:1 delegate:self];
    }
    else{
        [self showErrorView:@"Connessione assente"];
    }
    
}

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


//lasciare vuoto per levare effetto shadow nel  container
- (void)styleContainer:(UIView *)container animate:(BOOL)animate duration:(NSTimeInterval)duration {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) networkStatusChanged:(NSNotification*) notification
{
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

#pragma mark - WMHTTPAccessDelegate
-(void)didReceiveJSON:(NSArray *)jsonArray{
    //NSLog(@"JSON = %@",jsonArray);
    json = jsonArray;
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"Server error = %@",error.description);
    [self showErrorView:@"Errore server"];
}

#pragma mark - FACEBOOK
- (void)postToFacebook:(id)sender {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        //ios 6
        [self postWithIos6Api];
    }
    else{
        //ios5
        [self authButtonAction:self];
    }
}

-(void)postWithIos6Api{
    SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                    //TODO: mostrare hud successo
                }
                    break;
            }};
        
        //[fbController addImage:[UIImage imageNamed:@"1.jpg"]];
        [fbController setInitialText:[NSString stringWithFormat:@"News ClubMedici: \n%@",[[json objectAtIndex:0] objectForKey:@"titolo"]]];
        [fbController addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.clubmedici.it/nuovo/pagina.php?art=1&pgat=%@",[[json objectAtIndex:0] objectForKey:@"id"]]]];
        [fbController setCompletionHandler:completionHandler];
        [self presentViewController:fbController animated:YES completion:nil];
    }
    
}

#pragma mark - Action methods

- (void)authButtonAction:(id)sender {
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    //[appDelegate openSessionWithAllowLoginUI:YES];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        //inizia la procedura di pubblicazione
        [self publishAction:self];
    } else {
        //lancia il login a facebook
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
    
    
}

- (void)publishAction:(id)sender {
    // Put together the dialog parameters
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"News ClubMedici", @"name",
     [[json objectAtIndex:0] objectForKey:@"titolo"], @"caption",
     /*@"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",*/
     [NSString stringWithFormat:@"http://www.clubmedici.it/nuovo/pagina.php?art=1&pgat=%@",[[json objectAtIndex:0] objectForKey:@"id"]], @"link",
     [NSString stringWithFormat:@"http://www.clubmedici.it/nuovo/%@",[[json objectAtIndex:0]objectForKey:@"foto"]], @"picture",
     nil];
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     //TODO: mostrare hud di successo
                 }
             }
         }
     }];
}

-(void)logoutFromFB:(id)sender{
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    [appDelegate closeSession];
}


#pragma mark - Helper methods

/*
 * Configure the logged in versus logged out UI
 */
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
        
        [self postToFacebook:self];
    } else {
        NSLog(@"SLOGGATO");
        self.navigationItem.rightBarButtonItem = nil;
    }
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}



@end
