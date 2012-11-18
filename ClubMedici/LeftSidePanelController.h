//
//  ViewController.h
//  ClubMedici
//
//  Created by mario greco on 17/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSidePanelController : UIViewController

@property (nonatomic, weak, readonly) UILabel *label;
@property (nonatomic, weak, readonly) UIButton *hide;
@property (nonatomic, weak, readonly) UIButton *show;
@property (nonatomic, weak, readonly) UIButton *removeRightPanel;
@property (nonatomic, weak, readonly) UIButton *addRightPanel;
@property (nonatomic, weak, readonly) UIButton *changeCenterPanel;
@end
