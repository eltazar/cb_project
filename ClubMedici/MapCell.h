//
//  MapCell.h
//  ClubMedici
//
//  Created by mario on 09/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import<MapKit/MapKit.h>
typedef enum _MapCellState {
    MApClose = 1,
    MApOpen,
} MapCellState;

@interface MapCell : UITableViewCell <UIGestureRecognizerDelegate>{
}

@property (nonatomic, strong) MKMapView * mapView;
@property(assign) MapCellState mapState;

- (void)setMapEnabled:(BOOL)isEnable;
-(void)setMapFrame:(CGRect)frame;





@end