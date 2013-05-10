//
//  ContattiViewController.h
//  ClubMedici
//
//  Created by mario greco on 29/01/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMTableViewDataSource.h"
#import <MapKit/MapKit.h>
#import "Sede.h"
#import "Utilities.h"

@interface ContattiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, MKMapViewDelegate>{
    
    @protected
    WMTableViewDataSource *_dataModel;
    IBOutlet MKMapView *mapView;
    NSMutableArray *sediPin;
    NSInteger companyDescriptionCellCollapsedHeight;
}
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) MKMapView *mapView;
@end
