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


@implementation AppDelegate
@synthesize jasSidePanelController, splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
    }
    else {
        splitViewController = [[UISplitViewController alloc] init];
        splitViewController.viewControllers = [NSArray arrayWithObjects:self.sideMenuNavController, self.detailViewNavController, nil];
        splitViewController.delegate = [self.detailViewNavController.viewControllers objectAtIndex:0];
        self.window.rootViewController = splitViewController;
    }
    
    //oggetto reachability per controllare stato di rete
     Reachability* reachability = [Reachability reachabilityForInternetConnection];
    
//    [[NSNotificationCenter defaultCenter] addObserver:[[UIApplication sharedApplication] delegate]
//                                             selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
    [reachability startNotifier];
        
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
    NSLog(@"addPanGestureToView");
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(_handlePan:)];
    panGesture.delegate = [DummyGestureRecognizerDelegate sharedInstance];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    [navCon.view addGestureRecognizer:panGesture];
}

- (void) reachabilityChanged:(NSNotification*) notification
{
	Reachability* reachability = notification.object;
    NSLog(@"*** AppDelegate: networkStatusChanged ***");
	if(reachability.currentReachabilityStatus == NotReachable)
		NSLog(@"Internet off");
	else
		NSLog(@"Internet on");
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
                //NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
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
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
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

