//
//  AreaBaseControllerViewController.h
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AreaBase;
@interface AreaBaseController : UITableViewController

@property(nonatomic, strong) AreaBase *area;

- (id) initWithArea:(AreaBase*)area;
@end
