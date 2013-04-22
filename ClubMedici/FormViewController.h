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

@protocol FormViewControllerDelegate <NSObject>

-(void)didPressCancelButton:(id)sender;
-(void)didPressOkButton:(id)sender;

@end

@interface FormViewController : UITableViewController <UITextFieldDelegate> {
    @protected
    WMTableViewDataSource *_dataModel;
    
}

@property(nonatomic, weak) id<FormViewControllerDelegate> delegate;
-(BOOL) validateFields;
@end
