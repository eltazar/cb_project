//
//  ErrorView.m
//  ClubMedici
//
//  Created by mario on 28/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "ErrorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ErrorView
@synthesize label, tapRecognizer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ErrorView"
                                                          owner:self
                                                        options:nil];
        [self addSubview:[nibViews objectAtIndex:0]];
        
        
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(-2, 1);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.8;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
