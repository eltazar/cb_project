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
#import "AreaBase.h"

@interface AreaBaseController_iPhone () {
    AreaDescriptionCell *_areaDescriptionCell;
}
@end

@implementation AreaBaseController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _areaDescriptionCell = [[[NSBundle mainBundle] loadNibNamed:@"AreaDescriptionCell"
                                                          owner:nil
                                                        options:nil] objectAtIndex:0];
    
    [self setupBackgroundView];
    
    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


# pragma mark - iOS 5 specific


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    if (indexPath.section == 0 && indexPath.row == 0) {
        // _areaDescriptionCell.backgroundView = [[CustomCellBackground alloc] init];
        // _areaDescriptionCell.selectedBackgroundView = [[CustomCellBackground alloc] init];
        _areaDescriptionCell.collapsedHeight = 70;
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
