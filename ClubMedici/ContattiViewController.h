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


@interface ContattiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, MKMapViewDelegate>{
    
    @protected
    WMTableViewDataSource *_dataModel;
    MKMapView *mapView;
    UITableView *tableView;
    NSMutableArray *sediPin;

}
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet MKMapView *mapView;
@end
