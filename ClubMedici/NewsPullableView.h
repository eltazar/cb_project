//
//  NewsPullableView.h
//  ClubMedici
//
//  Created by mario on 26/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "PullableView.h"
#import "FXLabel.h"
@interface NewsPullableView : PullableView

@property(nonatomic, strong) IBOutlet UILabel *descrizioneBreve;
@property(nonatomic, strong) IBOutlet UIWebView *descrizioneEstesa;
@property(nonatomic, strong) UIButton *fbButton;
@property(nonatomic, strong) UIButton *mailButton;
@property(nonatomic, strong) UIButton *twButton;

-(void)rotateArrow:(BOOL)isUp;

@end
