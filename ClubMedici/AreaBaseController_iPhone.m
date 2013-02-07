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
#import "AreaBase.h"
#import "WMTableViewDataSource.h"

@interface AreaBaseController_iPhone () {
    AreaDescriptionCell *_areaDescriptionCell;
}
@end

@implementation AreaBaseController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ViewDidLoad: AreaBaseController_iPhone");
    
    _areaDescriptionCell = [[[NSBundle mainBundle] loadNibNamed:@"AreaDescriptionCell"
                                                          owner:nil
                                                        options:nil] objectAtIndex:0];
    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


# pragma mark - iOS 5 specific

//
//per gestire rotazione guardare qui: http://stackoverflow.com/questions/12536645/rotation-behaving-differently-on-ios6

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    if ([dataKey isEqualToString:@"description"]) {
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

- (void) setupBackgroundView{
    
    CGFloat tableViewWidth = self.tableView.frame.size.width;
    UIView *backgroundView = [[UIView alloc]init];
    imageView.frame = CGRectMake(0, 0,
                                 tableViewWidth,    
                                 tableViewWidth * (imageView.image.size.height / imageView.image.size.width)
                                 );
    [backgroundView addSubview:imageView];
    self.tableView.backgroundView = backgroundView;
    
    //per fare in modo che l'immagine nell'header diventi trasparente gradualmente verso la fine dell'immagine stessaUIView *backgroundView = [[UIView alloc] init];
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = imageView.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    l.startPoint = CGPointMake(1.0f, .6f);
    l.endPoint = CGPointMake(1.0f, 1.0f);
    imageView.layer.mask = l;
    
    
    //per far iniziare la tableView con un offset
    [UIView animateWithDuration:.5
                     animations:^(void) {
                         self.tableView.tableHeaderView =
                         [[UIView alloc] initWithFrame:
                          CGRectMake(0, 0,
                                     tableViewWidth,
                                     0.6 * imageView.frame.size.height
                                     )
                          ];
                     }
     ];
    NSLog(@"frame.width = %f, height = %f", tableViewWidth,backgroundView.frame.size.height);
}

-(void) computeImageSize{

}

@end
