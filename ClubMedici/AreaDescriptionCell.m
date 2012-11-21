//
//  AreaDescriptionCell.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaDescriptionCell.h"

#define DEFAULT_HEIGHT 131

@interface AreaDescriptionCell() {
    UILabel *_label;
    NSInteger _height;
    BOOL _isExpanded;
}
@end


@implementation AreaDescriptionCell

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
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    /* Regoliamo le dimensioni ottimali della label: la larghezza è quella impostata nello xib,
     * l'altezza gliela facciamo calcolare in modod che includa tutto il testo.*/
    _label = (UILabel *)[self viewWithTag:1];
    CGRect oldLblFrame = _label.frame;
    _label.numberOfLines = 0;
    [_label sizeToFit];
    /* Dopo il sizeToFit la cella risulta allargata, quindi prendiamo semplicemente il vecchio
     * frame e ci settiamo sopra la nuova altezza. */
    oldLblFrame.size.height = _label.frame.size.height;
    _label.frame = oldLblFrame;
    
    _isExpanded = FALSE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

# pragma mark - Public Methods

- (NSInteger)getHeight {
    CGFloat height;
    if (_isExpanded) {
        CGRect frame = _label.frame;
        height = frame.size.height + 2 * frame.origin.y; // La y fa da padding.
    }
    else {
        height = DEFAULT_HEIGHT;
    }
    return height;
}

# pragma mark - Private Methods

- (void)handleTap {
    _isExpanded =  !_isExpanded;
    if ([self.superview isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.superview;
        /* Da: WWDC 2010, Mastering Table Views.
         * il blocco begin/end updates vuoto fa si che la tableView ricalcoli la sua geometria,
         * aggiornando quindi l'altezza di questa cella. */
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}

@end
