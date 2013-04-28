//
//  CustomSpinnerView.m
//  ClubMedici
//
//  Created by mario on 28/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "CustomSpinnerView.h"

@implementation CustomSpinnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //Create the first status image and the indicator view
        UIImage *statusImage = [UIImage imageNamed:@"spinner0.png"];
        
        self.image = statusImage;
        
        //Add more images which will be used for the animation
        self.animationImages = [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"spinner30.png"],
                                             [UIImage imageNamed:@"spinner60.png"],
                                             [UIImage imageNamed:@"spinner90.png"],
                                             [UIImage imageNamed:@"spinner120.png"],
                               [UIImage imageNamed:@"spinner150.png"],
        [UIImage imageNamed:@"spinner180.png"],
        [UIImage imageNamed:@"spinner210.png"],
        [UIImage imageNamed:@"spinner240.png"],
                                [UIImage imageNamed:@"spinner270.png"],
        [UIImage imageNamed:@"spinner300.png"],
        [UIImage imageNamed:@"spinner330.png"],
                                 [UIImage imageNamed:@"spinner360.png"],
                                             nil];
        
        self.frame = CGRectMake( frame.size.width/2
                                             -statusImage.size.width/2,
                                             frame.size.height/2
                                             -statusImage.size.height/2,
                                             statusImage.size.width,
                                             statusImage.size.height);
        
        //Set the duration of the animation (play with it
        //until it looks nice for you)
        self.animationDuration = 1.1;
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
