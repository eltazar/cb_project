//
//  DocumentoAreaController.h
//  ClubMedici
//
//  Created by mario on 30/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHTTPAccess.h"
#import <MessageUI/MessageUI.h>
#import "ErrorView.h"
#import "CustomSpinnerView.h"
#import "Utilities.h"

@class AreaTurismoItem;

@interface DocumentoAreaController : UIViewController<WMHTTPAccessDelegate, UIActionSheetDelegate, UIWebViewDelegate, MFMailComposeViewControllerDelegate,UIPrintInteractionControllerDelegate>{
    @protected
    NSString *phone;
    NSString *mail;
    ErrorView *errorView;
    CustomSpinnerView *spinner;
    IBOutlet UIView *footerView;
    NSString *htmlPage;
}

@property(nonatomic, strong) NSDictionary *docItem;
@property(nonatomic, strong) AreaTurismoItem *turismoItem;

@property(nonatomic, weak) IBOutlet UIButton *callButton;
@property(nonatomic, weak) IBOutlet UIButton *mailButton;
@property(nonatomic, weak) IBOutlet UIWebView *webView;
-(IBAction) writeEmail;
-(IBAction)callNumber;
-(void)showErrorView:(NSString*)message;
-(void)hideErrorView:(UITapGestureRecognizer*)gesture;
-(void)fetchData;
@end
