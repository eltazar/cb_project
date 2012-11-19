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

@property (strong, nonatomic) UIViewController *sideMenuController;
@property (strong, nonatomic) UIViewController *detailViewController;

@end
