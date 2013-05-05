//
//  AreaBaseController.h
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "UIViewController+InterfaceIdiom.h"
#import "CachedAsyncImageView.h"
#import "RichiestaNoleggioController.h"
#import "PDHTTPAccess.h"
#import "WMHTTPAccess.h"
#import "ErrorView.h"
#import "CalcolaRataController.h"
#import "CustomSpinnerView.h"
#import "AreaBase.h"


@class AreaBase, WMTableViewDataSource;

@interface AreaBaseController : UITableViewController <MFMailComposeViewControllerDelegate,
                                    CachedAsyncImageViewDelegate,
                                    FormViewControllerDelegate,
                                    WMHTTPAccessDelegate,
                                    AreaDelegate> {
    @protected
        AreaBase *area;
        WMTableViewDataSource *_dataModel;
        CachedAsyncImageView *imageView;
        ErrorView *errorView;
        CustomSpinnerView *spinner;
}

@property(nonatomic, strong) AreaBase *area;
@property(nonatomic, assign) int        areaId;

- (id) initWithArea:(AreaBase*)area;
- (void) showErrorView:(NSString*)message;
- (void)hideErrorView:(UITapGestureRecognizer*)gesture;
@end


