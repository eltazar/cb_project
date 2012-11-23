//
//  FormViewController.h
//  ClubMedici
//
//  Created by mario greco on 22/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormViewController : UITableViewController <UITextFieldDelegate>

-(id) initWithDataModel:(NSDictionary*)dataModel;
@end
