//
//  PDFviewerWebViewViewController.h
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFviewerController : UIViewController<UIWebViewDelegate>
@property(nonatomic, strong) IBOutlet UIWebView *webView;
@end