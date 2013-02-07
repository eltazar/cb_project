//
//  FormViewController.h
//  ClubMedici
//
//  Created by mario greco on 22/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@class WMTableViewDataSource;

@interface FormViewController : UITableViewController <UITextFieldDelegate> {
    @protected
    WMTableViewDataSource *_dataModel;
    
}

-(BOOL) validateFields;
@end
