//
//  DisclaimerController.m
//  ClubMedici
//
//  Created by mario on 22/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DisclaimerController.h"

@interface DisclaimerController ()

@end

@implementation DisclaimerController
@synthesize disclamierTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Informativa";
    // Do any additional setup after loading the view from its nib.+
    
//            CALayer *imageLayer = disclamierTextView.layer;
//            [imageLayer setCornerRadius:6];
//            [imageLayer setBorderWidth:1];
//            imageLayer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UISwipeGestureRecognizer *swipeGestue = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBackWithSwipe:)];
        [swipeGestue setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:swipeGestue];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return YES;
    }
    else return NO;
}

-(void)goBackWithSwipe:(UISwipeGestureRecognizer*)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
