//
//  AreaBaseControllerViewController.h
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "UIViewController+InterfaceIdiom.h"
#import "CachedAsyncImageView.h"

@class AreaBase, WMTableViewDataSource;

@interface AreaBaseController : UITableViewController <MFMailComposeViewControllerDelegate, CachedAsyncImageViewDelegate> {
    @protected
        AreaBase *area;
        WMTableViewDataSource *_dataModel;
        CachedAsyncImageView *imageView;

}

@property(nonatomic, strong) AreaBase *area;

- (id) initWithArea:(AreaBase*)area;

@end
