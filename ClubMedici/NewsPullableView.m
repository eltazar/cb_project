//
//  NewsPullableView.m
//  ClubMedici
//
//  Created by mario on 26/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NewsPullableView.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface NewsPullableView(){
}
@end


@implementation NewsPullableView
@synthesize descrizioneBreve, descrizioneEstesa;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:45/255.0f green:101/255.0f blue:201/255.0f alpha:1.0];;//[UIColor colorWithRed:207/255.0f green:216/255.0f blue:226/255.0f alpha:1];
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0.5f, -3);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.3;
        
        descrizioneBreve = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 300, 25)];
        descrizioneBreve.text = @"News: caricamento...";
        descrizioneBreve.textColor = [UIColor whiteColor];
        [descrizioneBreve setFont: [UIFont fontWithName:@"Helvetica-Bold" size:15.0 ]];
        descrizioneBreve.backgroundColor = [UIColor clearColor];
        [descrizioneBreve setAdjustsFontSizeToFitWidth:YES];
        descrizioneBreve.minimumFontSize = 11;

        if (IS_IPHONE_5){
            // this is an iPhone 5+
            descrizioneEstesa = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, 457)];
        }
        else{
            descrizioneEstesa = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, 367)];
        }
  
        descrizioneEstesa.opaque = NO;
        descrizioneEstesa.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        descrizioneEstesa.backgroundColor = [UIColor colorWithRed:207/255.0f green:216/255.0f blue:226/255.0f alpha:1];

        //[self addSubview:title];
        [self addSubview:descrizioneBreve];
        [self addSubview:descrizioneEstesa];
        
        //rimuove ombra dietro la pagina web
        for(UIView *wview in [[[descrizioneEstesa subviews] objectAtIndex:0] subviews]) {
            if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
        }
        
        UIView *shadowLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width,1)];
        shadowLine.backgroundColor = [UIColor colorWithRed:45/255.0f green:101/255.0f blue:201/255.0f alpha:1.0];
        shadowLine.layer.masksToBounds = NO;
        shadowLine.layer.shadowOffset = CGSizeMake(-1, 2);
        shadowLine.layer.shadowRadius = 4;
        shadowLine.layer.shadowOpacity = 2;
        [self addSubview:shadowLine];    
    }
    return self;
}

@end
