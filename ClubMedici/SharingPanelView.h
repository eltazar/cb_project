//
//  SharingPanelView.h
//  ClubMedici
//
//  Created by mario greco on 05/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharingPanelView : UIView
@property(nonatomic, strong) UIButton *fbButton;
@property(nonatomic, strong) UIButton *mailButton;
@property(nonatomic, strong) UIButton *twButton;

-(void)setOrigin:(CGPoint)origin;
@end
