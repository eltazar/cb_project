//
//  SideMenu.m
//  ClubMedici
//
//  Created by mario greco on 18/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "SideMenuController.h"
#import "AppDelegate.h"
#import "UIViewController+InterfaceIdiom.h"
#import "JASidePanelController.h"



@interface SideMenuController()
@end

@implementation SideMenuController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _dataModel = [[WMTableViewDataSource alloc] initWithPList:@"SideMenu"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //TODO: da sistemare la sua posizione nella navBar
    self.title = @"Menu";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.dataSource = _dataModel;
    _dataModel.cellFactory = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    cell.textLabel.text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Table view delegate

@end
