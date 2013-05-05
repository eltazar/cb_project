//
//  SharingPanelView.m
//  ClubMedici
//
//  Created by mario greco on 05/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "SharingPanelView.h"

@implementation SharingPanelView
@synthesize fbButton,twButton,mailButton;

-(id)init{
    self = [super init];
    if(self){
        self.frame = CGRectMake(0, 0, 192, 36);
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        
        
        self.fbButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 36)];
        fbButton.opaque = YES;
        [fbButton setBackgroundImage:[UIImage imageNamed:@"fbButton"] forState:UIControlStateNormal];
        [self addSubview:self.fbButton];
        
        self.twButton = [[UIButton alloc] initWithFrame:CGRectMake(64, 0, 64, 36)];
        twButton.opaque = YES;
        [twButton setBackgroundImage:[UIImage imageNamed:@"twButton"] forState:UIControlStateNormal];
        [self addSubview:self.twButton];
        
        self.mailButton = [[UIButton alloc] initWithFrame:CGRectMake(128, 0, 64, 36)];
        mailButton.opaque = YES;
        [mailButton setBackgroundImage:[UIImage imageNamed:@"mailButton"] forState:UIControlStateNormal];
        [self addSubview:self.mailButton];

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setOrigin:(CGPoint)origin{
    self.frame = self.frame = CGRectMake(origin.x, origin.y, 192, 36);
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
