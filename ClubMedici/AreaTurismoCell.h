//
//  AreaTurismoCell.h
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 06/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AreaTurismoCell : UITableViewCell

@property (nonatomic, strong) UINavigationController *navController;

- (void)setItems:(NSArray *)items;
- (void)handleTap:(UITapGestureRecognizer *)sender;
- (NSInteger)getHeight;

@end
