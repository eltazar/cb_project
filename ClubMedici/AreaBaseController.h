//
//  AreaBaseController.h
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+InterfaceIdiom.h"
#import "RichiestaNoleggioController.h"
#import "CalcolaRataController.h"

#import "AreaDescriptionCell.h"
#import "CustomSpinnerView.h"
#import "ErrorView.h"

#import "AreaBase.h"

#import "CachedAsyncImageView.h"
#import "PDHTTPAccess.h"
#import "WMHTTPAccess.h"


@class AreaBase, WMTableViewDataSource;

@interface AreaBaseController : UITableViewController <
                                    CachedAsyncImageViewDelegate,
                                    FormViewControllerDelegate,
                                    WMHTTPAccessDelegate,
                                    BusinessLogicDelegate> {
    @protected
        AreaBase *area;
        WMTableViewDataSource *_dataModel;
        CachedAsyncImageView *imageView;
        ErrorView *errorView;
        CustomSpinnerView *spinner;
        AreaDescriptionCell *_areaDescriptionCell;
        NSInteger areaDescriptionCellCollapsedHeight;
}

@property(nonatomic, strong) AreaBase *area;
@property(nonatomic, assign) int       areaId;

- (id)initWithArea:(AreaBase*)area;
- (void)showErrorView:(NSString*)message;
- (void)hideErrorView:(UITapGestureRecognizer*)gesture;
- (void)fetchData;
@end


