//
//  DescrizioneAreaController.h
//  ClubMedici
//
//  Created by mario on 23/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHTTPAccess.h"

@interface DocumentoAreaController : UIViewController <WMHTTPAccessDelegate>

@property(nonatomic, strong) IBOutlet UIWebView *webView;
@property(nonatomic, strong) NSString *idPag;
@end
