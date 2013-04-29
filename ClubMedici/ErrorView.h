//
//  ErrorView.h
//  ClubMedici
//
//  Created by mario on 28/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorView : UIView

@property(nonatomic, strong) IBOutlet UILabel *label;
@property(nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic, assign) BOOL showed;
@end
