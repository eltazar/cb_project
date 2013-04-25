//
//  AreaDescriptionCell.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"

#import "AreaDescriptionCell.h"

@interface AreaDescriptionCell() {
    UILabel *_label;
    UILabel *_label_full;
    BOOL _isExpanded;
    CAGradientLayer *_alphaMask;
    UIView *_expandIndicator;
    CGFloat _collapsedHeight;
}
@end


@implementation AreaDescriptionCell

@synthesize collapsedHeight = _collapsedHeight;

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
    _isExpanded = FALSE;
    _collapsedHeight = 60.0f;
    _label_full = [[UILabel alloc] init];
    
    self.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    [self setUpLabel];
    [self addExpandIndicator];
    [self buildAlphaMask];
    
    [self addSubview: _label_full];
    _label.layer.mask = _alphaMask;
    
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview.opaque = YES;
    bgview.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];//[UIColor whiteColor];
    [self setBackgroundView:bgview];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


# pragma mark - Property Methods


- (void)setCollapsedHeight:(CGFloat)collapsedHeight {
    _collapsedHeight = collapsedHeight;
    [self buildAlphaMask];
    _label.layer.mask = _alphaMask;
}

- (NSString *)text {
    return _label.text;
}

- (void)setText:(NSString *)text {
    _label.text = text;
    [self setUpLabel];
    //NSLog(@"setText!");
}


# pragma mark - Public Methods


- (NSInteger)getHeight {
    CGFloat height;
    if (_isExpanded) {
        CGRect frame = _label.frame;
        height = frame.size.height + 2 * frame.origin.y; // La y fa da padding.
    }
    else {
        height = _collapsedHeight;
    }
    return height;
}


# pragma mark - Private Methods


- (void)handleTap {
    /*   Da: WWDC 2010, Mastering Table Views.
     * un blocco begin/end updates, eventualmente vuoto fa si che la tableView
     * ricalcoli la sua geometria, aggiornando quindi l'altezza di questa cella.*/
    [UIView animateWithDuration:0.3 animations:^{
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
    }];
}

- (void)setUpLabel {
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
    
    //per shadow inset
    //http://stackoverflow.com/questions/5817330/apply-inner-shadow-to-uilabel
    _label.textColor     = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    _label.shadowColor   = [UIColor blackColor];
    _label.shadowOffset  = CGSizeMake(-1.0,-1.0);
    
    _label_full.frame = _label.frame;
    _label_full.text = _label.text;
    _label_full.font = _label.font;
    _label_full.numberOfLines = _label.numberOfLines;
    _label_full.baselineAdjustment = _label.baselineAdjustment;
    _label_full.backgroundColor = _label.backgroundColor;
    _label_full.opaque = _label.opaque;
    _label_full.alpha = _isExpanded ? 1 : 0;
    
    _label_full.textColor     = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    _label_full.shadowColor   = [UIColor blackColor];
    _label_full.shadowOffset  = CGSizeMake(-1.0,-1.0);
}

- (void)addExpandIndicator {
    CGSize size = CGSizeMake(13, 10.0);
    CGPoint origin = CGPointMake(0, 0);
    CGRect rect = CGRectMake(origin.x, origin.y, size.width, size.height);
    CGFloat padding = 5;
    CGFloat t = 4;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint points[6];
    points[0].x = 0;
    points[0].y = size.height - size.width / 2;
    points[1].x = t*pow(cos(M_PI/4),2);
    points[1].y = size.height - size.width / 2 - t*pow(cos(M_PI/4),2);
    points[2].x = size.width / 2;
    points[2].y = size.height - t;
    points[3].x = size.width - t*pow(cos(M_PI/4),2);
    points[3].y = size.height - size.width / 2 - t*pow(cos(M_PI/4),2);
    points[4].x = size.width;
    points[4].y = size.height - size.width / 2;
    points[5].x = size.width / 2;
    points[5].y = size.height;
    CGPathAddLines(path, nil, points, 6);
    [[UIColor  colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1] setFill];
    [[UIBezierPath bezierPathWithCGPath:path] fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect imageFrame = rect;
    imageFrame.origin.x = self.frame.size.width - rect.size.width - padding;
    imageFrame.origin.y = self.frame.size.height - rect.size.height- padding;
    _expandIndicator = [[UIImageView alloc] initWithFrame:imageFrame];
    _expandIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [(UIImageView *)_expandIndicator setImage:image];
    [self addSubview:_expandIndicator];
}

- (void)buildAlphaMask {
    _alphaMask = [CAGradientLayer layer];
    CGColorRef topColor = CGColorRetain([UIColor colorWithWhite:1.0 alpha:1.0].CGColor);
    CGColorRef bottomColor = CGColorRetain([UIColor colorWithWhite:1.0 alpha:0.0].CGColor);
    _alphaMask.colors = [NSArray arrayWithObjects:
                        (__bridge id)topColor,
                        (__bridge id)topColor,
                        (__bridge id)bottomColor, nil];
    _alphaMask.locations = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.6],
                           [NSNumber numberWithFloat:(_collapsedHeight-2*_label.frame.origin.y)/_collapsedHeight], nil];
    _alphaMask.bounds = CGRectMake(0, 0,
                                  _label.frame.size.width, _collapsedHeight);
    _alphaMask.anchorPoint = CGPointZero;
    
    CGColorRelease(topColor);
    CGColorRelease(bottomColor);
}

@end
