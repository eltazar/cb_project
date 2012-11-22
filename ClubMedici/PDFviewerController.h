//
//  PDFviewerWebViewViewController.h
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFviewerController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate,UIPrintInteractionControllerDelegate>
@property(nonatomic, strong) IBOutlet UIWebView *webView;
@property(nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property(nonatomic, strong) IBOutlet UIBarButtonItem *actionButton;
@property(nonatomic, strong) IBOutlet UINavigationBar *toolBar;


-(id)initWithTitle:(NSString*)aTitle url:(NSString*)url;
-(IBAction)doneButtonPressed:(id)sender;
-(IBAction)actionButtonPressed:(id)sender;
-(IBAction)openIn:(id)sender;
@end
