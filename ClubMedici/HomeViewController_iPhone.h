//
//  HomeViewController_iPhone.h
//  ClubMedici
//
//  Created by mario greco on 19/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "HomeViewController.h"
#import "NewsPullableView.h"
#import "WMHTTPAccess.h"

@interface HomeViewController_iPhone : HomeViewController<PullableViewDelegate, WMHTTPAccessDelegate>

@end
