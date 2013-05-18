//
//  AppDelegate.h
//  ClubMedici
//
//  Created by mario greco on 17/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PushNotificationManager.h"

#define FBSessionStateChangedNotification @"FBSessionStateChangedNotification"

@class JASidePanelController, HomeViewController_iPad, SideMenuController_iPad;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PushNotificationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *sideMenuNavController;
@property (strong, nonatomic) UINavigationController *detailViewNavController;
@property (readonly,strong, nonatomic) JASidePanelController *jasSidePanelController;
@property (strong, nonatomic) UISplitViewController *splitViewController;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)closeSession;
@end



@interface DummyGestureRecognizerDelegate : NSObject<UIGestureRecognizerDelegate>
+ (DummyGestureRecognizerDelegate *)sharedInstance;
@end
