//
//  NewsPullableView.m
//  ClubMedici
//
//  Created by mario on 26/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "NewsPullableView.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@implementation NewsPullableView
@synthesize descrizioneBreve, descrizioneEstesa;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 50, 20)];
        title.text = @"News";
        title.textColor = [UIColor blackColor];
        descrizioneBreve = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 300, 45)];
        descrizioneBreve.backgroundColor = [UIColor grayColor];
        
       
        if (IS_IPHONE_5){
            // this is an iPhone 5+
            descrizioneEstesa = [[UIWebView alloc] initWithFrame:CGRectMake(10, 90, 300, 400)];
        }
        else{
            descrizioneEstesa = [[UIWebView alloc] initWithFrame:CGRectMake(10, 90, 300, 310)];
        }
        
        
        descrizioneEstesa.backgroundColor = [UIColor grayColor];
        descrizioneEstesa.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        
        [self addSubview:title];
        [self addSubview:descrizioneBreve];
        [self addSubview:descrizioneEstesa];
        
    }
    return self;
}

@end
