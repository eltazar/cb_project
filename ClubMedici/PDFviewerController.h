//
//  PDFviewerWebViewViewController.h
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFviewerController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate,UIPrintInteractionControllerDelegate>

@property(nonatomic, weak) IBOutlet UIWebView *webView;
@property(nonatomic, weak) IBOutlet UINavigationBar *navBar;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *actionButton;
@property(nonatomic, weak) IBOutlet UINavigationBar *toolBar;

@property(nonatomic, strong) NSString *urlString;


- (id)initWithTitle:(NSString*)aTitle url:(NSString*)url;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)openIn:(id)sender;
@end
