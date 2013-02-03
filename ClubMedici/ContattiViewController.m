//
//  ContattiViewController.m
//  ClubMedici
//
//  Created by mario greco on 29/01/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "ContattiViewController.h"
@interface ContattiViewController ()

@end

@implementation ContattiViewController
@synthesize mapView, tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Contatti";
	// Do any additional setup after loading the view.
    _dataModel = [[WMTableViewDataSource alloc] initWithPList:@"Contatti"];
    self.tableView.dataSource = _dataModel;
    _dataModel.cellFactory = self;
    _dataModel.showSectionHeaders = NO;

    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    NSArray *sedi = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Sedi" ofType:@"plist"]];
    sediPin = [[NSMutableArray alloc] init];
    
    for(NSDictionary *o in sedi){
        CLLocationCoordinate2D c = CLLocationCoordinate2DMake([[o objectForKey:@"LAT"] floatValue],[[o objectForKey:@"LONG"]floatValue]);
        Sede *s = [[Sede alloc] initWithCoordinate:c];
        NSLog(@"lat = %f, long = %f", c.latitude, c.longitude);
        [o objectForKey:@"LAT"];
        s.name = [o objectForKey:@"NAME"];
        s.city = [o objectForKey:@"CITY"];
        [sediPin addObject:s];
        NSLog(@"S = %@",s);
    }
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    [mapView addAnnotations:sediPin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActionCell" owner:self options:NULL] objectAtIndex:0];
    }
    UILabel *label   = (UILabel *)    [cell viewWithTag:1];
    UIImageView *img = (UIImageView *)[cell viewWithTag:2];
    
    label.text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
    
    if([dataKey isEqualToString:@"phone"]){
        [img setImage:[UIImage imageNamed:@"phone"]];
    }
    else if([dataKey isEqualToString:@"mail"]){
        [img setImage:[UIImage imageNamed:@"mail"]];
    }
    else{
        [img setImage:nil];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_dataModel tableView:tableView titleForHeaderInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    CustomHeader *header = [[CustomHeader alloc] init] ;
//    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
//    return header;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//    view.backgroundColor = [UIColor whiteColor];
//    return view;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

#pragma mark - MapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id )annotation
{    
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    
    if(pinView == nil){
        
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        //setto colore, disclosure button ed animazione
    }
    else{
        pinView.annotation = annotation;   
    }
    pinView.enabled = YES;
    pinView.canShowCallout = YES;
    return pinView;
}

//per gestire il tap sul disclosure
- (void)mapView:(MKMapView *)_mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
}

@end
