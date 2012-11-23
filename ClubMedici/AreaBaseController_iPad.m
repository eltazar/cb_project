//
//  AreaBaseController_iPad.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaBaseController_iPad.h"
#import "AreaBase.h"

@interface AreaBaseController_iPad ()

@end

@implementation AreaBaseController_iPad

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCellIpad"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AreaDescriptionCell_iPad" owner:self options:NULL] objectAtIndex:0];
        }
        
        UILabel *label = (UILabel*)[cell viewWithTag:2];
        UIImageView *imgView = (UIImageView*)[cell viewWithTag:1];
        
        label.text = self.area.descrizione;
        
    }
    else {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 219.0f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}



@end
