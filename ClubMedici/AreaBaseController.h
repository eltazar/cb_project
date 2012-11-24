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

@class AreaBase, WMTableViewDataModel;

@interface AreaBaseController : UITableViewController <MFMailComposeViewControllerDelegate> {
    @protected
        AreaBase *area;
        WMTableViewDataModel *_dataModel;
}

@property(nonatomic, strong) AreaBase *area;

- (id) initWithArea:(AreaBase*)area;

@end
