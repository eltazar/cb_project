//
//  ErrorView.h
//  ClubMedici
//
//  Created by mario on 28/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorView : UIView

@property(nonatomic, weak) IBOutlet UILabel *label;
@property(nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic, assign) BOOL showed;

-(id)initWithSize:(CGSize)size;
@end
