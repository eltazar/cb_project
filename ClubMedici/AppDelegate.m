//
//  AppDelegate.m
//  ClubMedici
//
//  Created by mario greco on 17/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController_iPhone.h"
#import "HomeViewController_iPad.h"
#import "SideMenuController_iPhone.h"
#import "SideMenuController_iPad.h"
#import "HomeViewController_iPad.h"

#import "JASidePanelController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.sideMenuController = [[UINavigationController alloc] initWithRootViewController:[[SideMenuController_iPhone alloc] initWithNibName:@"SideMenuController_iPhone" bundle:nil]];
        self.detailViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController_iPhone alloc] initWithNibName:@"HomeViewController_iPhone" bundle:nil]];
        JASidePanelController *jasSidePanelController = [[JASidePanelController alloc] init];
        jasSidePanelController.leftPanel = self.sideMenuController;
        jasSidePanelController.centerPanel = self.detailViewController;
        jasSidePanelController.shouldDelegateAutorotateToVisiblePanel = NO;
        self.window.rootViewController = jasSidePanelController;
    }
    else {
        self.sideMenuController = [[SideMenuController_iPad alloc] initWithNibName:@"SideMenuController_iPad" bundle:nil];
        self.detailViewController = [[HomeViewController_iPad alloc] initWithNibName:@"HomeViewController_iPad" bundle:nil];
        UINavigationController *menuNav= [[UINavigationController alloc] initWithRootViewController:self.sideMenuController];
        UINavigationController *detailNav = [[UINavigationController alloc]initWithRootViewController:self.detailViewController];
        
        UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
        splitViewController.viewControllers = [NSArray arrayWithObjects:menuNav, detailNav, nil];
        splitViewController.delegate = (HomeViewController_iPad *)self.detailViewController;
        // Add the split view controller's view to the window and display.
        // [self.window addSubview:self.splitViewController.view];
        self.window.rootViewController = splitViewController;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
