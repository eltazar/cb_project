//
//  FormViewController.h
//  ClubMedici
//
//  Created by mario greco on 22/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMTableViewDataModel;

@interface FormViewController : UITableViewController <UITextFieldDelegate> {
    @protected
    WMTableViewDataModel *_dataModel;
}

@end
