//
//  WebViewCell.m
//  ClubMedici
//
//  Created by mario on 09/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "WebViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        self.frame = CGRectMake(0, 0, 320, 94);
        CGRect webViewFrame = CGRectMake(0.0, 1.0, self.contentView.bounds.size.width, 92);
        webView = [[UIWebView alloc] initWithFrame:webViewFrame];
        webView.tag = 3;
        webView.userInteractionEnabled = NO;
        
        webView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:webView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, 0.0f,1024, 1.5f);
            bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
            
            //linea separatrice alta 1px, posizionata alla base inferiore della cella
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
            line.opaque = YES;
            line.tag = 999;
            line.layer.borderColor = [UIColor colorWithRed:214/255.0f green:226/255.0f blue:241/255.0f alpha:1].CGColor;
            line.layer.borderWidth = 1.0;
            //applico bordo inferiore
            [line.layer addSublayer:bottomBorder];
            //applico linea alla cella
            [self.contentView addSubview:line];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
