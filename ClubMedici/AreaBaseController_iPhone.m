//
//  AreaController_iPhone.m
//  ClubMedici
//
//  Created by mario greco on 23/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>

#import "AreaDescriptionCell.h"
#import "AreaBaseController_iPhone.h"
#import "CustomCellBackground.h"
#import "CustomHeader.h"

@interface AreaBaseController_iPhone ()
{
    AreaDescriptionCell *_areaDescriptionCell;
}
@end

@implementation AreaBaseController_iPhone

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
    static int flag = NO;
    if (indexPath.section == 0 && indexPath.row == 0) {
        _areaDescriptionCell.backgroundView = [[CustomCellBackground alloc] init];
        _areaDescriptionCell.selectedBackgroundView = [[CustomCellBackground alloc] init];
        _areaDescriptionCell.collapsedHeight = 70;
        if (flag)
        _areaDescriptionCell.text = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like). Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32.";
        flag = YES;

        
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
