//
//  AreaBaseController_iPad.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//
#include <QuartzCore/QuartzCore.h>

#import "AreaBaseController_iPad.h"
#import "AreaBase.h"
#import "WMTableViewDataSource.h"
#import "AreaDescriptionCell.h"

@interface AreaBaseController_iPad ()
{
    AreaDescriptionCell *_areaDescriptionCell;
}
@end

@implementation AreaBaseController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ViewDidLoad: AreaBaseController_iPad");

    
    // Do any additional setup after loading the view from its nib.
    _areaDescriptionCell = [[[NSBundle mainBundle] loadNibNamed:@"AreaDescriptionCell_iPad"
                                                          owner:nil
                                                        options:nil] objectAtIndex:0];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if ([dataKey isEqualToString:@"description"]) {
        _areaDescriptionCell.collapsedHeight = 120;
        _areaDescriptionCell.text = self.area.descrizione;
        return _areaDescriptionCell;

    }
    else {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        AreaDescriptionCell *cell = (AreaDescriptionCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell getHeight];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
