//
//  AreaController_iPhone.m
//  ClubMedici
//
//  Created by mario greco on 23/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>

#import "AreaDescriptionCell.h"
#import "AreaController_iPhone.h"
#import "CustomCellBackground.h"
#import "CustomHeader.h"

@interface AreaController_iPhone ()
{
    AreaDescriptionCell *_areaDescriptionCell;
}
@end

@implementation AreaController_iPhone

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    _areaDescriptionCell = [[[NSBundle mainBundle] loadNibNamed:@"AreaDescriptionCell"
                                                          owner:nil
                                                        options:nil] objectAtIndex:0];
    
    [self setupBackgroundView];
    
    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//per ios 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        _areaDescriptionCell.backgroundView = [[CustomCellBackground alloc] init];
        _areaDescriptionCell.selectedBackgroundView = [[CustomCellBackground alloc] init];
        
        // At end of function, right before return cell:
        _areaDescriptionCell.textLabel.backgroundColor = [UIColor clearColor];
        return _areaDescriptionCell;

    }    
    else {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        AreaDescriptionCell *cell = (AreaDescriptionCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell getHeight];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

# pragma mark - Private Methods

- (void)setupBackgroundView {
    UIImage *image = [UIImage imageNamed:@"finanziariaImg.jpg"];
    UIView *backgroundView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat tableViewWidth = self.tableView.frame.size.width;
    imageView.frame = CGRectMake(0, 0,
                                 tableViewWidth,
                                 tableViewWidth * (image.size.height / image.size.width)
                                 );
    
    //per fare in modo che l'immagine nell'header diventi trasparente gradualmente verso la fine dell'immagine stessa
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = imageView.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    l.startPoint = CGPointMake(1.0f, .6f);
    l.endPoint = CGPointMake(1.0f, 1.0f);
    imageView.layer.mask = l;
    
    [backgroundView addSubview:imageView];
    self.tableView.backgroundView = backgroundView;
    self.tableView.tableHeaderView =
    [[UIView alloc] initWithFrame:
     CGRectMake(0, 0,
                tableViewWidth,
                0.6 * imageView.frame.size.height
                )
     ];
}

@end
