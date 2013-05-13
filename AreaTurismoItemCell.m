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
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [self initialize];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initialize {
    UIView *v = [[UIView alloc] init];
    v.opaque = YES;
    v.backgroundColor = v.backgroundColor = [UIColor colorWithRed:144/255.0f
                                                            green:170/255.0f
                                                             blue:201/255.0f
                                                            alpha:1];
    self.selectedBackgroundView = v;
    
    self.titleLbl.textColor = [UIColor colorWithRed:11/255.0f
                                              green:67/255.0f
                                               blue:144/255.0f
                                              alpha:1];
    /*Testo della cella*/
    self.descriptionLbl.textColor     = [UIColor colorWithRed:1.0
                                                        green:1.0
                                                         blue:1.0
                                                        alpha:0.2];
    self.descriptionLbl.shadowColor   = [UIColor blackColor];
    self.descriptionLbl.shadowOffset  = CGSizeMake(-0.5,-0.5);
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
