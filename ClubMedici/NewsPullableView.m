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
#define degreesToRadians(x)(x * M_PI / 180)

@interface NewsPullableView(){
    UIImageView *arrow;
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

        
        self.opaque = YES;
        descrizioneEstesa.opaque = YES;
        descrizioneBreve.opaque = YES;
        
        //[self addSubview:title];
        [self addSubview:descrizioneBreve];
        [self addSubview:descrizioneEstesa];
        
        //rimuove ombra dietro la pagina web
        for(UIView *wview in [[[descrizioneEstesa subviews] objectAtIndex:0] subviews]) {
            if([wview isKindOfClass:[UIImageView class]]) { wview.hidden = YES; }
        }
        
        //inserisco top & bottom shadow in questa maniera per motivi di performance
        UIView *shadowLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width,1)];
        shadowLine.backgroundColor = [UIColor colorWithRed:45/255.0f green:101/255.0f blue:201/255.0f alpha:1.0];
        shadowLine.opaque = YES;
        shadowLine.layer.masksToBounds = NO;
        shadowLine.layer.shadowOffset = CGSizeMake(-1, 2);
        shadowLine.layer.shadowRadius = 4;
        shadowLine.layer.shadowOpacity = 2;
        [self addSubview:shadowLine];
        
        shadowLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,1.5f)];
        shadowLine.backgroundColor = [UIColor colorWithRed:45/255.0f green:101/255.0f blue:201/255.0f alpha:1.0];
        shadowLine.layer.masksToBounds = NO;
        shadowLine.layer.shadowOffset = CGSizeMake(-1, -3);
        shadowLine.layer.shadowRadius = 4;
        shadowLine.layer.shadowOpacity = 6;
        [self addSubview:shadowLine];
        
        arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowUp"]];
        
        arrow.frame = CGRectMake(self.frame.size.width-25, 8,14, 11);
        
        [self addSubview:arrow];
    }
    return self;
}

-(void)rotateArrow:(BOOL)isUp{
    
    //http://stackoverflow.com/questions/3587636/animate-rotating-uiimageview
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if(isUp){
        arrow.transform = CGAffineTransformMakeRotation(degreesToRadians(180));
    }
    else{
        //per ruotare a partire dallo stato precedente
        arrow.transform = CGAffineTransformRotate(arrow.transform, degreesToRadians(180));
    }
    
    [UIView commitAnimations];
}

@end
