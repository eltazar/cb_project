//
//  AppDelegate.h
//  ClubMedici
//
//  Created by mario greco on 17/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JASidePanelController, HomeViewController_iPad, SideMenuController_iPad,AreaBaseController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *sideMenuNavController;
@property (strong, nonatomic) UINavigationController *detailViewNavController;
@property (readonly,strong, nonatomic) JASidePanelController *jasSidePanelController;
@property(nonatomic, strong)AreaBaseController *areaController;

@end



@interface DummyGestureRecognizerDelegate : NSObject<UIGestureRecognizerDelegate>
+ (DummyGestureRecognizerDelegate *)sharedInstance;
@end
