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
@interface DocumentoAreaController : UIViewController<WMHTTPAccessDelegate,MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UIPrintInteractionControllerDelegate, UIWebViewDelegate>{
    @protected
    NSString *phone;
    NSString *mail;
    ErrorView *errorView;
    CustomSpinnerView *spinner;
    IBOutlet UIView *footerView;
}

@property(nonatomic, weak) IBOutlet UIButton *callButton;
@property(nonatomic, weak) IBOutlet UIButton *mailButton;
@property(nonatomic, strong) NSString *idPag;
@property(nonatomic, weak) IBOutlet UIWebView *webView;
-(IBAction) writeEmail;
-(IBAction)callNumber;
-(void)showErrorView:(NSString*)message;
-(void)hideErrorView:(UITapGestureRecognizer*)gesture;
-(void)fetchData;
@end
