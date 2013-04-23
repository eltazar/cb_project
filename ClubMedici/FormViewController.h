//
//  FormViewController.h
//  ClubMedici
//
//  Created by mario greco on 22/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "DisclaimerController.h"
@class WMTableViewDataSource;

@protocol FormViewControllerDelegate <NSObject>

-(void)didPressCancelButton:(id)sender;
-(void)didPressOkButton:(id)sender;

@end

@interface FormViewController : UITableViewController <UITextFieldDelegate> {
    @protected
    WMTableViewDataSource *_dataModel;
    UILabel *customTitle;
    
}

@property(nonatomic, weak) id<FormViewControllerDelegate> delegate;
-(BOOL) validateFields;
@end
