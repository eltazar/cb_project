//
//  WebViewCell.m
//  ClubMedici
//
//  Created by mario on 09/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "WebViewCell.h"

@implementation WebViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        self.frame = CGRectMake(0, 0, 320, 94);
        CGRect webViewFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        webView = [[UIWebView alloc] initWithFrame:webViewFrame];
        webView.tag = 3;
        webView.userInteractionEnabled = NO;
        
        webView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:webView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
