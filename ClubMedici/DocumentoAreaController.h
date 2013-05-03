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

@interface DocumentoAreaController : UIViewController<WMHTTPAccessDelegate,MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UIPrintInteractionControllerDelegate, UIWebViewDelegate>{
    NSString *phone;
    NSString *mail;
    ErrorView *errorView;
}

@property(nonatomic, strong) IBOutlet UIButton *callButton;
@property(nonatomic, strong) IBOutlet UIButton *mailButton;
@property(nonatomic, strong) NSString *idPag;
@property(nonatomic, strong) IBOutlet UIWebView *webView;
-(IBAction) writeEmail;
-(IBAction)callNumber;
-(void)showErrorView:(NSString*)message;
-(void)hideErrorView:(UITapGestureRecognizer*)gesture;
-(void)fetchData;
@end
