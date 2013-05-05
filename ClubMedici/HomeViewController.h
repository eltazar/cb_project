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
#import <MessageUI/MessageUI.h>
#import "SharingPanelView.h"


@interface HomeViewController : UIViewController<WMHTTPAccessDelegate, MFMailComposeViewControllerDelegate>
{
    ErrorView *errorView;

}- (void) showErrorView:(NSString*)message;
- (void)hideErrorView:(UITapGestureRecognizer*)gesture;

- (void)postToFacebook:(id)sender;
- (void)postToTwitter:(id)sender;

@end
