//
//  AreaTurismoController.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 06/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "AreaTurismoController.h"
#import "WMTableViewDataSource.h"
#import "AreaTurismoCell.h"

#define ROW_HEIGHT (160 * 3)

@interface AreaTurismoController ()

@end

@implementation AreaTurismoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"AreaTurismoController didLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRow di AreaTurismoController");
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if (indexPath.section == 1 && [dataKey isEqualToString:@"ViaggiTurismo"]) {
        NSLog(@"CELLONE!");
        cell = [tableView dequeueReusableCellWithIdentifier:@"ViaggiTurismo"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AreaTurismoCell"
                                                  owner:self
                                                options:NULL] objectAtIndex:0];
        }
        AreaTurismoCell *turismoCell = (AreaTurismoCell *)cell;
        turismoCell.navController = self.navigationController;
        [turismoCell setItems:[_dataModel valueForKey:@"ITEMS" atIndexPath:indexPath]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}



#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if (indexPath.section == 1 && [dataKey isEqualToString:@"ViaggiTurismo"]) {
        return ROW_HEIGHT;
    }
    return tableView.rowHeight;
}




@end
