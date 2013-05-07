//
//  AreaTurismoCell.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 06/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "AreaTurismoCell.h"
#import "TurismoTableViewController.h"

#define N                 5
#define IMAGEVIEW_OFFSET  0
#define LABEL_OFFSET     10

@interface AreaTurismoCell () {
    NSArray *_items;
}
@end

@interface UITapGestureRecognizerWithTag : UITapGestureRecognizer
    @property (nonatomic, assign) NSInteger tag;
@end


@implementation AreaTurismoCell


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


- (void)initialize {
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



# pragma mark - Private Methods


- (void)handleTap {

}



# pragma mark - Public Methods

- (void)setItems:(NSArray *)items {
    _items = items;
    for (int i = 0; i < N; i++) {
        NSDictionary *dict      = (NSDictionary *)  [items objectAtIndex:i];
        UILabel *label          = (UILabel *)       [self viewWithTag:LABEL_OFFSET + i];
        UIImageView *imageView  = (UIImageView *)   [self viewWithTag:IMAGEVIEW_OFFSET + i];
        
        label.text      = [dict objectForKey:@"LABEL"];
        imageView.image = [UIImage imageNamed:[dict objectForKey:@"IMAGE"]];
        
        UITapGestureRecognizerWithTag *tapGestureRecognizer = [[UITapGestureRecognizerWithTag alloc] initWithTarget:self action:@selector(handleTap:)];
        [tapGestureRecognizer setCancelsTouchesInView:NO];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer.tag = i;
    }
}


- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded &&
        [sender isKindOfClass:[UITapGestureRecognizerWithTag class]]) {
        NSInteger tag = ((UITapGestureRecognizerWithTag *)sender).tag;
        NSDictionary *dict = (NSDictionary *) [_items objectAtIndex:tag];
        TurismoTableViewController *viewController = [[TurismoTableViewController alloc] init];
        viewController.title = [dict objectForKey:@"LABEL"];
        //viewController.idTipo
        [self.navController pushViewController:viewController animated:YES];
    }
}


@end


@implementation UITapGestureRecognizerWithTag
@end
