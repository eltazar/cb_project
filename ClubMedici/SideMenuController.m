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
    NSLog(@"cell height = %f",cell.frame.size.height);
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview.opaque = YES;
    bgview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side_menu_background"]];
    [cell setBackgroundView:bgview];
    
    //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side_menu_background"]];
    return cell;
}


#pragma mark - Table view delegate
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_dataModel tableView:tableView titleForHeaderInSection:section];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *sectionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"side_menu_sec_background"]];
    sectionView.alpha = 0.95;
    
    //Add label to view
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, -9, 320, 40)];
    titleLabel.backgroundColor =[UIColor clearColor];
    [titleLabel setFont: [UIFont fontWithName:@"Helvetica-Bold" size:16.5f ]];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [sectionView addSubview:titleLabel];
    
    return sectionView;
}
@end
