//
//  AppDelegate.h
//  ClubMedici
//
//  Created by mario greco on 17/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JASidePanelController, HomeViewController_iPad, SideMenuController_iPad;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JASidePanelController *viewController;
@property (strong, nonatomic) UISplitViewController *splitViewController;
@property (strong, nonatomic) HomeViewController_iPad *homeViewController_ipad;
@property (strong, nonatomic) SideMenuController_iPad *sideMenuController_ipad;

@end
