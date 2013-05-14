//
//  AreaTurismoItemCell.h
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaTurismoItem.h"
#import "CachedAsyncImageView.h"

@interface AreaTurismoItemCell : UITableViewCell 

@property(nonatomic, strong) IBOutlet CachedAsyncImageView *photo;
@property(nonatomic, strong) IBOutlet UILabel *titleLbl;
@property(nonatomic, strong) IBOutlet UILabel *descriptionLbl;

@property(nonatomic, strong) AreaTurismoItem *areaTurismoItem;

- (NSInteger)getHeight;

@end
