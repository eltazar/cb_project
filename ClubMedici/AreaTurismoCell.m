//
//  AreaTurismoCell.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 06/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "AreaTurismoCell.h"

#define N                 5
#define IMAGEVIEW_OFFSET  0
#define LABEL_OFFSET     10

@interface AreaTurismoCell () {
    NSMutableArray *_gestureRecognizers;
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
    _gestureRecognizers = [[NSMutableArray alloc] initWithCapacity:N];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



# pragma mark - Private Methods


- (void)handleTap {
    /*   Da: WWDC 2010, Mastering Table Views.
     * un blocco begin/end updates, eventualmente vuoto fa si che la tableView
     * ricalcoli la sua geometria, aggiornando quindi l'altezza di questa cella.*/
    /*[UIView animateWithDuration:0.3 animations:^{
        UITableView *tableView = (UITableView *)self.superview;
        if (![tableView isKindOfClass:[UITableView class]]) {
            tableView = nil;
        }
        [tableView beginUpdates];
        
        if (_isExpanded) {
            _label.alpha = 1;
            _label_full.alpha = 0;
            _expandIndicator.transform = CGAffineTransformIdentity;
        }
        else {
            _label.alpha = 0;
            _label_full.alpha = 1;
            _expandIndicator.transform = CGAffineTransformMakeRotation(M_PI);
        }
        _isExpanded =  !_isExpanded;
        
        [tableView endUpdates];
    }];*/
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
        
        UITapGestureRecognizerWithTag *tapGestureRecognizer = [[UITapGestureRecognizerWithTag alloc] initWithTarget:self action:@selector(handleTap)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        [_gestureRecognizers insertObject:tapGestureRecognizer atIndex:i];
        tapGestureRecognizer.tag = i;
    }
}


- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        for (UITapGestureRecognizer *recognizer in _gestureRecognizers) {
            if (recognizer == sender) {
                NSLog(@"Ho fatto tap su ");
            }
        }
    }
}


@end


@implementation UITapGestureRecognizerWithTag
@end
