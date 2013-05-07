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
#import "MBProgressHUD.h"
#import "PDHTTPAccess.h"
#import "WMHTTPAccess.h"

@class WMTableViewDataSource;

@protocol FormViewControllerDelegate <NSObject>

-(void)didPressCancelButton:(id)sender;
-(void)didPressOkButton:(id)sender;

@end

@interface FormViewController : UITableViewController <UITextFieldDelegate, WMHTTPAccessDelegate> {
    @protected
    WMTableViewDataSource *_dataModel;    
}

@property(nonatomic, weak) id<FormViewControllerDelegate> delegate;
-(BOOL) validateFields;
-(void)sendRequest;
-(NSString*)createHtmlBody;
@end
