//
//  MapCell.m
//  ClubMedici
//
//  Created by mario on 09/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "MapCell.h"
#import "Sede.h"
#import <QuartzCore/QuartzCore.h>

@implementation MapCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.mapState = MApClose;
    self.frame = CGRectMake(0, 0, 320, 100);
    CGRect mapFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    self.mapView = [[MKMapView alloc] initWithFrame:mapFrame];
    _mapView.opaque = YES;
    _mapView.tag = 1;
    _mapView.userInteractionEnabled = NO;
    
    _mapView.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
   [self.contentView addSubview:self.mapView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 8)];
    topView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"topShadow"]];
    topView.opaque = YES;
    [self.mapView addSubview:topView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-8, self.frame.size.width, 9)];
    bottomView.opaque = YES;
    bottomView.autoresizingMask =  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottomShadow"]];
    [self.mapView addSubview:bottomView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMapCenter:(MKCoordinateRegion)region{
    [_mapView setRegion:region animated:NO];
}

- (void)layoutSubViews
{
    [super layoutSubviews];
    // layout stuff relative to the size of the cell.
    
}

- (void)setMapEnabled:(BOOL)isEnable;{
    _mapView.userInteractionEnabled = isEnable;
}

-(void)setMapFrame:(CGRect)frame{
    _mapView.frame = frame;
}

@end
