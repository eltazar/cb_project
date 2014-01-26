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
    UIButton* _lastButtonTouched;
}
- (UIView *)getViewForLocation:(CGPoint)location;
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
    _lastButtonTouched = nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



# pragma mark - Private Methods


- (UIView *)getViewForLocation:(CGPoint)location {
    // Il motivo per cui devo scendere di DUE livelli nelle subviews è mistero della fede -_-
    for (UIView *view in ((UIView*)[self.subviews objectAtIndex:0]).subviews) {
        CGRect subviewFrame = view.frame;
        if (view.tag != 0 && CGRectContainsPoint(subviewFrame, location)) {
            NSLog(@"tag view tappata: %d", view.tag);
            return view;
        }
    }
    return nil;
}

- (void)setImage:(NSString *)imageName ForButton:(UIButton *)btn {
    if (iPadIdiom()) imageName = ORIENTATION_SPECIFIC_STRING(imageName);
    UIImage* image = [UIImage imageNamed: IDIOM_SPECIFIC_STRING(imageName)];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
}



# pragma mark - Public Methods

- (void)setItems:(NSArray *)items {
    _items = items;
    for (int i = 0; i < N; i++) {
        NSDictionary *dict      = (NSDictionary *)  [items objectAtIndex:i];
        UIButton *btn           = (UIButton *)      [self viewWithTag:BUTTON_OFFSET + i];
        FXLabel *label          = (FXLabel *)       [self viewWithTag:LABEL_OFFSET + i];
        UIImageView *imageView  = (UIImageView *)   [self viewWithTag:IMAGEVIEW_OFFSET + i];
        
        [self setImage:@"AreaTurismoCellBg" ForButton:btn];
        /*NSString *imageName = @"AreaTurismoCellBg";
        if (iPadIdiom()) imageName = ORIENTATION_SPECIFIC_STRING(imageName);
        UIImage *image = [UIImage imageNamed:IDIOM_SPECIFIC_STRING(imageName)];
        [btn setBackgroundImage:image
                       forState:UIControlStateNormal];
        imageName = @"AreaTurismoCellBgHigh";
        if (iPadIdiom()) imageName = ORIENTATION_SPECIFIC_STRING(imageName);

        image = [UIImage imageNamed: IDIOM_SPECIFIC_STRING(imageName)];
        [btn setBackgroundImage:image
                       forState:UIControlStateHighlighted];*/
        //[btn addTarget:self
        //        action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
      
        label.text      = [dict objectForKey:@"LABEL"];
        label.shadowBlur = 6.0;
        label.shadowColor = [UIColor colorWithRed:3/255.0
                                            green:84/255.0
                                             blue:175/255.0 alpha:1];
        
        
        UIImage* image = [UIImage imageNamed:IDIOM_SPECIFIC_STRING([dict objectForKey:@"IMAGE"])];
        imageView.image = image;
        
        //UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        //[self addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        UIButton* btn = (UIButton*)[self getViewForLocation:[touch locationInView:self]];
        [self setImage:@"AreaTurismoCellBgHigh" ForButton:btn];
        _lastButtonTouched = btn;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        UIButton* btn = (UIButton*)[self getViewForLocation:[touch locationInView:self]];
        if (!btn || btn != _lastButtonTouched) {
            [self setImage:@"AreaTurismoCellBg" ForButton:_lastButtonTouched];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        UIButton* btn = (UIButton*)[self getViewForLocation:[touch locationInView:self]];
        if (btn == _lastButtonTouched) {
            [self setImage:@"AreaTurismoCellBg" ForButton:btn];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Began");
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Ended");
    }
    
    NSInteger tag = [((UIView*)[self getViewForLocation:
                               [recognizer locationInView:self]]) tag] - BUTTON_OFFSET;
    
    if (tag < 0) return;
    
    
    NSDictionary *dict = (NSDictionary *) [_items objectAtIndex:tag];
    TurismoTableViewController *viewController = [[TurismoTableViewController alloc] initWithNibName:nil bundle:nil];
    viewController.title = [dict objectForKey:@"LABEL"];
    AreaTurismoSection *areaTurismoSection = [[AreaTurismoSection alloc] init];
    areaTurismoSection.sectionId = [[dict valueForKey:@"DATA_KEY"] intValue];
    viewController.areaTurismoSection = areaTurismoSection;
    [self.navController pushViewController:viewController animated:YES];
    /*}
     else if (sender.state == UIGestureRecognizerStateBegan) {
        UIImageView *imageView
    }*/
}


- (NSInteger)getHeight {
    return self.frame.size.height;
}




@end


@implementation UITapGestureRecognizerWithTag
@end
