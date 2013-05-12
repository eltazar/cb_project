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
    
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBarLogo"] forBarMetrics:UIBarMetricsDefault];
    //rimuove shadow sotto navBar
    //self.navigationController.navigationBar.clipsToBounds = YES;
    if ([self.navigationController.navigationBar
         respondsToSelector:@selector(shadowImage)]) {
        self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"side_menu_separation_line"];
    }
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43,320, 4)];
    separatorLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side_menu_separation_line"]];

    [self.navigationController.navigationBar addSubview:separatorLine];

    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cmLogo"]];
    logo.frame = CGRectMake(50, 7, 158, 30);
    //self.navigationItem.titleView = logo;

    [self.navigationController.navigationBar addSubview:logo];
    
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
        UIView *v = [[UIView alloc] init];
        v.opaque = YES;
        v.backgroundColor = [UIColor colorWithRed:144/255.0f green:170/255.0f blue:201/255.0f alpha:1];
        cell.selectedBackgroundView = v;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"  %@",[_dataModel valueForKey:@"LABEL" atIndexPath:indexPath]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1,cell.frame.size.width, 2)];
    separatorLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"side_menu_separation_line"]];
    [cell.contentView addSubview:separatorLine];

    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return 0.0;
    
    return UITableViewAutomaticDimension;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_dataModel tableView:tableView titleForHeaderInSection:section];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.textColor = [UIColor colorWithRed:10/255.0f green:78/255.0f blue:154/255.0f alpha:1];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return nil;
    
    UIImageView *sectionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"side_menu_sec_background"]];
    //sectionView.alpha = 0.95;
    
    //Add label to view
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, -9, 320, 40)];
    titleLabel.backgroundColor =[UIColor clearColor];
    [titleLabel setFont: [UIFont fontWithName:@"Helvetica-Bold" size:16.5f ]];
    titleLabel.textColor = [UIColor colorWithRed:144/255.0 green:170/255.0 blue:201/255.0 alpha:1];
    titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [sectionView addSubview:titleLabel];
    
    return sectionView;
}
@end
