//
//  SideMenu.h
//  ClubMedici
//
//  Created by mario greco on 18/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+InterfaceIdiom.h"
#import "RichiestaIscrizioneController.h"
#import "WMTableViewDataSource.h"
#import "ContattiViewController.h"
#import "AreaBase.h"
#import "HomeViewController.h"
#import "AreaBaseController.h"


@interface SideMenuController : UITableViewController
{
    WMTableViewDataSource *_dataModel;
}
@end
