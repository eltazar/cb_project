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
#import "UnderlinedLabel.h"

#define URL_NEWS_PATH @"http://www.clubmedici.it/nuovo/"

@interface HomeViewController : UIViewController<WMHTTPAccessDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate>
{
    @protected
    ErrorView *errorView;
    IBOutlet UIWebView * webView;
    FXLabel *titleLabel;
    IBOutlet UIView *footerView;
}

- (void)showErrorView:(NSString*)message;
- (void)hideErrorView:(UITapGestureRecognizer*)gesture;

- (void)postToFacebook:(id)sender;
- (void)postToTwitter:(id)sender;

@end
