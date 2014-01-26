//
//  AreaTurismoCell.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 06/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "AreaTurismoCell.h"
#import "AreaTurismoSection.h"
#import "TurismoTableViewController.h"
#import "UIViewController+InterfaceIdiom.h"
#import "FXLabel.h"

#define N                 5
#define BUTTON_OFFSET    30
#define IMAGEVIEW_OFFSET 10
#define LABEL_OFFSET     20

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




# pragma mark - Public Methods



- (void)setItems:(NSArray *)items {
    _items = items;
    for (NSDictionary *dict in items) {
        NSInteger i             = [[dict objectForKey:@"DATA_KEY"] integerValue] - 1;
        UIButton *btn           = (UIButton *)      [self viewWithTag:BUTTON_OFFSET + i];
        FXLabel *label          = (FXLabel *)       [self viewWithTag:LABEL_OFFSET + i];
        UIImageView *imageView  = (UIImageView *)   [self viewWithTag:IMAGEVIEW_OFFSET + i];
        
        NSString *imageName = @"AreaTurismoCellBg";
        if (iPadIdiom()) imageName = ORIENTATION_SPECIFIC_STRING(imageName);
        UIImage *image = [UIImage imageNamed:IDIOM_SPECIFIC_STRING(imageName)];
        [btn setBackgroundImage:image
                       forState:UIControlStateNormal];
        imageName = @"AreaTurismoCellBgHigh";
        if (iPadIdiom()) imageName = ORIENTATION_SPECIFIC_STRING(imageName);
        image = [UIImage imageNamed: IDIOM_SPECIFIC_STRING(imageName)];
        [btn setBackgroundImage:image
                       forState:UIControlStateHighlighted];
        [btn addTarget:self
                action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self bringSubviewToFront:btn];
      
        label.text       = [dict objectForKey:@"LABEL"];
        label.shadowBlur = 6.0;
        label.shadowColor = [UIColor colorWithRed:3/255.0
                                            green:84/255.0
                                             blue:175/255.0 alpha:1];
        
        
        image = [UIImage imageNamed:IDIOM_SPECIFIC_STRING([dict objectForKey:@"IMAGE"])];
        imageView.image = image;
    }
}


- (void)buttonClicked:(UIView *)sender {
    NSInteger tag = sender.tag - BUTTON_OFFSET;
    
    NSDictionary *dict = (NSDictionary *) [_items objectAtIndex:tag];
    TurismoTableViewController *viewController = [[TurismoTableViewController alloc] initWithNibName:nil bundle:nil];
    viewController.title = [dict objectForKey:@"LABEL"];
    AreaTurismoSection *areaTurismoSection = [[AreaTurismoSection alloc] init];
    areaTurismoSection.sectionId = [[dict valueForKey:@"DATA_KEY"] intValue];
    viewController.areaTurismoSection = areaTurismoSection;
    [self.navController pushViewController:viewController animated:YES];
}




- (NSInteger)getHeight {
    return self.frame.size.height;
}




@end


@implementation UITapGestureRecognizerWithTag
@end
