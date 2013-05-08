//
//  UnderlinedLabel.m
//  ClubMedici
//
//  Created by mario on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "UnderlinedLabel.h"

@implementation UnderlinedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGSize expectedLabelSize = [self.text sizeWithFont:self.font
                                      constrainedToSize:self.frame.size
                                          lineBreakMode:self.lineBreakMode];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 149.0f/255.0f, 172.0f/255.0f, 197.0f/255.0f, 1.0f); // RGBA
    CGContextSetLineWidth(ctx, 1.0f);

    
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height - 1);
    CGContextAddLineToPoint(ctx,expectedLabelSize.width, self.bounds.size.height - 1);
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];
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
