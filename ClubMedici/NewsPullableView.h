//
//  NewsPullableView.h
//  ClubMedici
//
//  Created by mario on 26/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "PullableView.h"
#import "FXLabel.h"
@class SharingPanelView;
@interface NewsPullableView : PullableView

@property(nonatomic, strong) UILabel *descrizioneBreve;
@property(nonatomic, strong) UIWebView *descrizioneEstesa;
@property(nonatomic, strong) SharingPanelView *sharingView;

-(void)rotateArrow:(BOOL)isUp;

@end
