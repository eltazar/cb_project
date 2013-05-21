//
//  AppDelegate.m
//  ClubMedici
//
//  Created by mario greco on 17/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

#import "SideMenuController.h"
#import "HomeViewController.h"

#import "JASidePanelController.h"
#import "Flurry.h"
#import "SharingProvider.h"

#import "DocumentoAreaController.h"
#import "AreaTurismoItem.h"
#import "AreaBaseController.h"
#import "AreaBase.h"

@implementation AppDelegate
@synthesize jasSidePanelController, splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Flurry startSession:@"8XSPVFTVH247HKGKXB7T"];
    //push handling
	PushNotificationManager * pushManager = [PushNotificationManager pushManager];
    pushManager.delegate = self;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    self.sideMenuNavController = [[UINavigationController alloc] initWithRootViewController:[SideMenuController idiomAllocInit]];
    self.sideMenuNavController.navigationBar.tintColor = [UIColor colorWithRed:1/255.0f green:70/255.0f blue:148/255.0f alpha:1];
    self.detailViewNavController = [[UINavigationController alloc] initWithRootViewController:[HomeViewController idiomAllocInit]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        jasSidePanelController = [[JASidePanelController alloc] init];
        jasSidePanelController.leftPanel = self.sideMenuNavController;
        jasSidePanelController.centerPanel = self.detailViewNavController;
        jasSidePanelController.shouldDelegateAutorotateToVisiblePanel = YES;
        self.window.rootViewController = jasSidePanelController;
        [self addPanGestureToNavigationController:self.detailViewNavController target:jasSidePanelController];
        pushManager.supportedOrientations = PWOrientationPortrait;
    }
    else {
        splitViewController = [[UISplitViewController alloc] init];
        splitViewController.viewControllers = [NSArray arrayWithObjects:self.sideMenuNavController, self.detailViewNavController, nil];
        splitViewController.delegate = [self.detailViewNavController.viewControllers objectAtIndex:0];
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(312, 0, 9, 1020)];
        [coverView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sideShadow"]]];
        
        [splitViewController.view addSubview:coverView];
        
        self.window.rootViewController = splitViewController;
    }
    
    //oggetto reachability per controllare stato di rete
     Reachability* reachability = [Reachability reachabilityForInternetConnection];
    
//    [[NSNotificationCenter defaultCenter] addObserver:[[UIApplication sharedApplication] delegate]
//                                             selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
    [reachability startNotifier];
    
    //sharingProvider
    [SharingProvider sharedInstance];
    
    [self setCustomApparence];
        
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

- (void)addPanGestureToNavigationController:(UINavigationController *)navCon
                                   target:(id<UIGestureRecognizerDelegate>) target {
    //nslog(@"addPanGestureToView");
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(_handlePan:)];
    panGesture.delegate = [DummyGestureRecognizerDelegate sharedInstance];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    [navCon.view addGestureRecognizer:panGesture];
}

- (void) reachabilityChanged:(NSNotification*) notification
{
	//Reachability* reachability = notification.object;
    //nslog(@"*** AppDelegate: networkStatusChanged ***");
//	if(reachability.currentReachabilityStatus == NotReachable)
//		//nslog(@"Internet off");
//	else
//		//nslog(@"Internet on");
}

#pragma mark - FACEBOOK API

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                //nslog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    //nslog(@"APP DELEGATE = MANDO notifica: %d, %@",state,session);
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    //nslog(@"OPEN SESSION WITH GUI");
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

/*
 *
 */
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSLog(@"url recieved: %@", url);
    NSLog(@"query string: %@", [url query]);
    NSLog(@"host: %@", [url host]);
    NSLog(@"url path: %@", [url path]);
    NSDictionary *dict = [self parseQueryString:[url query]];
    NSLog(@"query dict: %@", dict);
    NSLog(@"totale = %@",[NSString stringWithFormat:@"%@%@%@",[url host], [url path],[url query]]);
    NSLog(@"scheme = %@",[url scheme]);    
    
    // controllo scheme e lancio qualche controller
    if([[url scheme] isEqualToString:@"doccontroller"]){
        DocumentoAreaController *docController = [DocumentoAreaController idiomAllocInit];
        docController.docItem = dict;
        docController.isPush = YES;
        //per aprire la push in qls controller dove è l'utente
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [(UINavigationController*)jasSidePanelController.centerPanel pushViewController:docController animated:YES];
        }
        else{
            
        }
        return YES;
    }
    else if([[url scheme] isEqualToString:@"pdfcontroller"]){
        
        AreaTurismoItem *turismo = [[AreaTurismoItem alloc] init];
        turismo.title = [dict objectForKey:@"title"];
        turismo.pdfUrl = [dict objectForKey:@"url"];
        DocumentoAreaController *docController = [DocumentoAreaController idiomAllocInit];
        docController.turismoItem = turismo;
        docController.isPush = YES;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [(UINavigationController*)jasSidePanelController.centerPanel pushViewController:docController animated:YES];
        }
        else{
            
        }
        return YES;
    }
    else if([[url scheme] isEqualToString:@"areacontroller"]){
        Class areaClass = NSClassFromString([AreaBase getAreaType:[[dict objectForKey:@"id"]intValue]]);
        AreaBase *area = [[areaClass alloc] initWithAreaId:[[dict objectForKey:@"id"]intValue]];
        NSLog(@"app delegate area id = %d",area.areaID);
        AreaBaseController *areaContr = [AreaBaseController idiomAllocInit];
        areaContr.area.areaID = area.areaID;
        areaContr.title = [dict objectForKey:@"title"];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [(UINavigationController*)jasSidePanelController.centerPanel pushViewController:areaContr animated:YES];
        }
        else{
            
        }
        return YES;
    }
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

#pragma mark - Apparence methods

- (void)setCustomApparence {
    UIColor *blue = [UIColor colorWithRed:3/255.0 green:84/255.0 blue:175/255.0 alpha:1];
    
    //permette di cambiare la navBar di tutte le view
    UIImage *image = [[UIImage imageNamed:@"iphone_nav_bar"]
                       resizableImageWithCapInsets: UIEdgeInsetsMake(20, 0, 20, 0)];
    [[UINavigationBar appearance] setBackgroundImage:image
                                       forBarMetrics:UIBarMetricsDefault];
    // Customize the title text for *all* UINavigationBars
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"System-Bold" size:0.0],
      UITextAttributeFont,
      nil]];
    
    // Change the appearance of back button
//    UIImage *backButtonImage = [[UIImage imageNamed:@"back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    
//    // Change the appearance of other navigation button
//    UIImage *barButtonImage = [[UIImage imageNamed:@"normal_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
//    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    //tintcolor per gli oggett nella navBar
    [[UIBarButtonItem appearance] setTintColor: blue];
    
    //tintColor per TableView
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1]];
    
    [[UISegmentedControl appearance] setTintColor:blue];
}

#pragma mark - PushWoosh

- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification onStart:(BOOL)onStart{
    
    //NSLog(@" \n \n \n ******** PUSH = %@ ******\n\n\n\n\n, onStart = %d",pushNotification, onStart);
    //NSLog(@"PUSH MANAGER PAYLOAD = %@", [[PushNotificationManager pushManager] getApnPayload:pushNotification]);
    
    //cliccata la push 
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end



@implementation DummyGestureRecognizerDelegate
// Sta roba volendo si può anche spostare :D

static DummyGestureRecognizerDelegate *__sharedInstance;

+ (id)alloc {
    NSAssert(__sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
    __sharedInstance = [super alloc];
    return __sharedInstance;
}


+ (DummyGestureRecognizerDelegate *)sharedInstance {
    if (!__sharedInstance) {
        __sharedInstance = [[DummyGestureRecognizerDelegate alloc] init];
    }
    return __sharedInstance;
}


#pragma mark - Gesture Recognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // TODO: investigare se sto YES a prescindere influisce su comportamenti vari.
    return YES;
}


@end

