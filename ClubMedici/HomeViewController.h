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
#import "AppDelegate.h"
#import "SharingPanelView.h"
#import "UnderlinedLabel.h"
#import "CustomSpinnerView.h"

#define URL_NEWS_IMG @"http://www.clubmedici.it/nuovo/"
#define URL_NEWS @"http://www.clubmedici.it/nuovo/pagina.php?art=1&pgat="
#define BASE_URL @"http://www.clubmedici.it/nuovo/"
@interface HomeViewController : UIViewController<WMHTTPAccessDelegate, UIActionSheetDelegate, UIWebViewDelegate> {
    @protected
    ErrorView *errorView;
    IBOutlet UIWebView * webView;
    FXLabel *titleLabel;
    IBOutlet UIView *footerView;
    IBOutlet UIButton *shareButton;
    CustomSpinnerView *spinner;

}

- (void)showErrorView:(NSString*)message;
- (void)hideErrorView:(UITapGestureRecognizer*)gesture;

- (IBAction)sharingAction:(id)sender;

@end
