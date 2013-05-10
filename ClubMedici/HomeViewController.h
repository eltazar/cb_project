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

#define URL_NEWS_IMG @"http://www.clubmedici.it/nuovo/"
#define URL_NEWS @"http://www.clubmedici.it/nuovo/pagina.php?art=1&pgat="
@interface HomeViewController : UIViewController<WMHTTPAccessDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate, UIActionSheetDelegate>
{
    @protected
    ErrorView *errorView;
    IBOutlet UIWebView * webView;
    FXLabel *titleLabel;
    IBOutlet UIView *footerView;
    IBOutlet UIButton *shareButton;
}

- (void)showErrorView:(NSString*)message;
- (void)hideErrorView:(UITapGestureRecognizer*)gesture;

-(IBAction)sharingAction:(id)sender;
@end
