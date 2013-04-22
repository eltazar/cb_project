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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ClubMedici";
}



//lasciare vuoto per levare effetto shadow nel  container
- (void)styleContainer:(UIView *)container animate:(BOOL)animate duration:(NSTimeInterval)duration {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
