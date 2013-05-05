//
//  AreaTurismoController.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 03/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "AreaTurismoController_iPhone.h"
#import "WMTableViewDataSource.h"

@interface AreaTurismoController_iPhone ()

@end

@implementation AreaTurismoController_iPhone

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Methods
- (void)fetchData {
    _dataModel = [[WMTableViewDataSource alloc] initWithPList:@"AreaTurismo"];
    //[self showData];
}


#pragma mark - Table view data source


/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if(indexPath.section == 0){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:NULL] objectAtIndex:0];
            UIView *v = [[UIView alloc] init];
            v.backgroundColor = [UIColor colorWithRed:210/255.0f green:230/255.0f blue:236/255.0f alpha:1];
            cell.selectedBackgroundView = v;
        }
        
        UILabel *contactLabel = (UILabel *) [cell viewWithTag:1];
        //        contactLabel.shadowColor = [UIColor colorWithWhite:1 alpha:1];
        //        contactLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        //        contactLabel.shadowBlur = 1.0f;
        //        contactLabel.innerShadowBlur = 3.0f;
        //        contactLabel.innerShadowColor = [UIColor colorWithRed:22/255.0f green:47/255.0f blue:156/255.0f alpha:1];
        //        contactLabel.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
        contactLabel.textColor = [UIColor colorWithRed:28/255.0f green:60/255.0f blue:119/255.0f alpha:1];
        
        contactLabel.highlightedTextColor =[UIColor blackColor];
        
        UIImageView *img = (UIImageView *)[cell viewWithTag:2];
    }
}*/


@end
