//
//  AreaTurismoItemCell.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "AreaTurismoItemCell.h"
#import "AsyncImageView.h"

@interface AreaTurismoItemCell() { }
    
@end

@implementation AreaTurismoItemCell

@synthesize areaTurismoItem = _areaTurismoItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setAreaTurismoItem:(AreaTurismoItem *)areaTurismoItem {
    _areaTurismoItem = areaTurismoItem;
    NSMutableString *imgUrl = [[areaTurismoItem.imageUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] mutableCopy];
    [imgUrl replaceOccurrencesOfString:@" " withString:@"%20" options:nil range:NSMakeRange(0, [imgUrl length])];
    [self.photo loadImageFromURL:[NSURL URLWithString:imgUrl]];
    self.titleLbl.text = areaTurismoItem.title;
    self.descriptionLbl.text = areaTurismoItem.description;
}


@end
