//
//  AreaDescriptionCell.h
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaDescriptionCell : UITableViewCell

- (NSInteger)getHeight;

@property (nonatomic, assign) CGFloat collapsedHeight;
@property (nonatomic) NSString *text;

@end
