//
//  ViewController.h
//  ClubMedici
//
//  Created by mario greco on 17/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"
#import "UIViewController+InterfaceIdiom.h"
#import "Utilities.h"
#import "ErrorView.h"
#import "WMHTTPAccess.h"
#import "PDHTTPAccess.h"
#import <Social/Social.h>
#import "AppDelegate.h"

@interface HomeViewController : UIViewController<WMHTTPAccessDelegate>
{
    ErrorView *errorView;

}- (void) showErrorView:(NSString*)message;
- (void)hideErrorView:(UITapGestureRecognizer*)gesture;

- (void)postToFacebook:(id)sender;

@end
