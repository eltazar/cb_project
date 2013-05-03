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
        self.backgroundColor = [UIColor colorWithRed:207/255.0f green:216/255.0f blue:226/255.0f alpha:1];
        self.layer.borderColor = [UIColor colorWithRed:78/255.0f green:111/255.0f blue:147/255.0f alpha:0.8].CGColor;
        self.layer.borderWidth = 0.8f;
        self.layer.masksToBounds = NO;
        //contactPanel.layer.cornerRadius = 8; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(0.5f, -4);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.3;
        
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0.5f, -3);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.3;
        
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 50, 20)];
//        title.text = @"News";
//        title.backgroundColor = [UIColor colorWithRed:207/255.0f green:216/255.0f blue:226/255.0f alpha:1];
//        title.textColor = [UIColor blackColor];
        
        descrizioneBreve = [[FXLabel alloc] initWithFrame:CGRectMake(15, 10, 300, 25)];
        descrizioneBreve.backgroundColor = [UIColor clearColor];
        [descrizioneBreve setAdjustsFontSizeToFitWidth:YES];
        descrizioneBreve.minimumFontSize = 11;
        descrizioneBreve.textColor = [UIColor colorWithRed:28/255.0f green:60/255.0f blue:119/255.0f alpha:1];
        //descrizioneBreve.backgroundColor = [UIColor blackColor];//[UIColor colorWithRed:207/255.0f green:216/255.0f blue:226/255.0f alpha:1];
        [descrizioneBreve setFont: [UIFont fontWithName:@"Helvetica-Bold" size:15.0 ]];
        descrizioneBreve.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
        descrizioneBreve.shadowOffset = CGSizeMake(0.8f, 0.80f);
        descrizioneBreve.shadowBlur = 1.0f;
        descrizioneBreve.innerShadowBlur = 3.0f;
        descrizioneBreve.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
        descrizioneBreve.innerShadowOffset = CGSizeMake(0.8f, 0.8f);
        descrizioneBreve.highlightedTextColor =[UIColor blackColor];

        if (IS_IPHONE_5){
            // this is an iPhone 5+
            descrizioneEstesa = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 450)];
        }
        else{
            descrizioneEstesa = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 360)];
        }
  
        descrizioneEstesa.opaque = NO;
        descrizioneEstesa.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        descrizioneEstesa.backgroundColor = [UIColor colorWithRed:207/255.0f green:216/255.0f blue:226/255.0f alpha:1];

        //[self addSubview:title];
        [self addSubview:descrizioneBreve];
        [self addSubview:descrizioneEstesa];
        
        
    
    }
    return self;
}

@end
