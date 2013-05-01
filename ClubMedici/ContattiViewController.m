//
//  ContattiViewController.m
//  ClubMedici
//
//  Created by mario greco on 29/01/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "ContattiViewController.h"
#import "FXLabel.h"

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
    
    sediPin = [[NSMutableArray alloc] init];
    
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSArray *sedi = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Sedi" ofType:@"plist"]];
    
    for(NSDictionary *o in sedi){
        CLLocationCoordinate2D c = CLLocationCoordinate2DMake([[o objectForKey:@"LAT"] floatValue],[[o objectForKey:@"LONG"]floatValue]);
        Sede *s = [[Sede alloc] initWithCoordinate:c];
        [o objectForKey:@"LAT"];
        s.name = [o objectForKey:@"NAME"];
        s.city = [o objectForKey:@"CITY"];
        [sediPin addObject:s];
    }
    [mapView addAnnotations:sediPin];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:NULL] objectAtIndex:0];
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor colorWithRed:210/255.0f green:230/255.0f blue:236/255.0f alpha:1];
        cell.selectedBackgroundView = v;
    }
    
    UIImageView *img = (UIImageView *)[cell viewWithTag:2];

    FXLabel *label   = (FXLabel*)    [cell viewWithTag:3];
    label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    label.shadowOffset = CGSizeMake(1.0f, 1.0f);
    label.shadowBlur = 1.0f;
    label.innerShadowBlur = 3.0f;
    label.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
    label.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    label.highlightedTextColor =[UIColor blackColor];
    
    NSLog(@"LABEL = %@",[_dataModel valueForKey:@"LABEL" atIndexPath:indexPath]);
    label.text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
    
    FXLabel *contactLabel = (FXLabel *) [cell viewWithTag:1];
    contactLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    contactLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    contactLabel.shadowBlur = 1.0f;
    contactLabel.innerShadowBlur = 3.0f;
    contactLabel.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
    contactLabel.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    contactLabel.highlightedTextColor =[UIColor blackColor];

    
    if([dataKey isEqualToString:@"phone"]){
        [img setImage:[UIImage imageNamed:@"phone"]];
        contactLabel.text = @"Telefono";
    }
    else if([dataKey isEqualToString:@"mail"]){
        [img setImage:[UIImage imageNamed:@"mail"]];
        contactLabel.text = @"E-mail";
    }
    else if([dataKey isEqualToString:@"facebook"]){
        contactLabel.text = @"Facebook";
        [img setImage:nil];
    }
    else if([dataKey isEqualToString:@"twitter"]){
        contactLabel.text = @"Twitter";
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
    [pinView setPinColor:MKPinAnnotationColorGreen];
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
