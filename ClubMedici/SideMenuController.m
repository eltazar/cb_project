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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview.opaque = YES;
    bgview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side_menu_cell_background"]];
    [cell setBackgroundView:bgview];
    cell.textLabel.text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *v = [[UIView alloc] init];
        v.opaque = YES;
        v.backgroundColor = [UIColor colorWithRed:133/255.0f green:196/255.0f blue:224/255.0f alpha:1];
        cell.selectedBackgroundView = v;
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}


#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 44)];
//    bgview.opaque = YES;
//    bgview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side_menu_cell_background"]];
//    [cell setBackgroundView:bgview];
//
//}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_dataModel tableView:tableView titleForHeaderInSection:section];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *sectionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"side_menu_sec_background"]];
    //sectionView.alpha = 0.95;
    
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
