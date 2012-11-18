//
//  ViewController.m
//  ClubMedici
//
//  Created by mario greco on 17/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //se commento da qui in poi il menu laterale salta fuori solo premendo il bottone e non più con la gesture
    
    CGFloat red = (CGFloat)arc4random() / 0x100000000;
    CGFloat green = (CGFloat)arc4random() / 0x100000000;
    CGFloat blue = (CGFloat)arc4random() / 0x100000000;
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UILabel *label  = [[UILabel alloc] init];
//    label.font = [UIFont boldSystemFontOfSize:20.0f];
//    label.text = @"Center Panel";
//    [label sizeToFit];
//    label.center = CGPointMake(floorf(self.view.bounds.size.width/2.0f), floorf((self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height)/2.0f));
//    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
//    [self.view addSubview:label];

    //[self.view addSubview:self.leftPanel.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
