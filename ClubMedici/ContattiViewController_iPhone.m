//
//  ContattiViewController_iPhone.m
//  ClubMedici
//
//  Created by mario greco on 29/01/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "ContattiViewController_iPhone.h"

@interface ContattiViewController_iPhone ()
{
    CGFloat _lastContentOffset;
    CGRect mapOriginalFrame;
    CLLocationCoordinate2D originalCenterCoordinate;
    CGFloat deltaLatFor1px;
}
@end

@implementation ContattiViewController_iPhone
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ContattiViewController_iPhone" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_contatti"]];
    
    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    
    tableView.backgroundColor = [UIColor clearColor];
    
    _lastContentOffset = -200.0;
    mapOriginalFrame = mapView.frame;
    originalCenterCoordinate = mapView.centerCoordinate;
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    [self.view insertSubview:mapView belowSubview:tableView];

    NSLog(@"tab x = %f, y = %f \n w = %f, h = %f \n contentoffset y = %f, contentsize = %f",self.tableView.frame.origin.x, self.tableView.frame.origin.y,self.tableView.frame.size.width,self.tableView.frame.size.height,self.tableView.contentOffset.y,self.tableView.contentSize.height);
    
    //cosi la mappa mantiene il focus su una certa zona
    //http://stackoverflow.com/questions/10979323/new-foursquare-venue-detail-map
    originalCenterCoordinate = CLLocationCoordinate2DMake(43.6010, 7.0774);
    mapView.region = MKCoordinateRegionMakeWithDistance(originalCenterCoordinate, 8000, 8000);
    mapView.centerCoordinate = originalCenterCoordinate;
    CLLocationCoordinate2D referencePosition = [mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:mapView];
    CLLocationCoordinate2D referencePosition2 = [mapView convertPoint:CGPointMake(0, 100) toCoordinateFromView:mapView];
    deltaLatFor1px = (referencePosition2.latitude - referencePosition.latitude)/100;
    
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
    
    if([dataKey isEqualToString:@"company"]){
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"WebViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"WebViewCell" owner:self options:NULL] objectAtIndex:0];
        }
        UIWebView *webView =(UIWebView*) [cell viewWithTag:3];
        [webView loadHTMLString:[_dataModel valueForKey:@"LABEL" atIndexPath:indexPath] baseURL:nil];
        UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        bgview.opaque = YES;
        bgview.backgroundColor = [UIColor whiteColor];
        [cell setBackgroundView:bgview];
    }
    else{
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview.opaque = YES;
    bgview.backgroundColor = [UIColor whiteColor];
    [cell setBackgroundView:bgview];

    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
 
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
//    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
//}

#pragma mark - UIScrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //set the frame of MKMapView based on scrollView.contentOffset and make sure the pin is at center of the map view
//
    NSLog(@"y = %f", scrollView.contentOffset.y);
    CGRect mapFrame = self.mapView.frame;

    CGFloat addFloat;    
    
    if(scrollView.contentOffset.y < 0){
        double deltaLat = scrollView.contentOffset.y*deltaLatFor1px;
        //Move the center coordinate accordingly
        CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(originalCenterCoordinate.latitude-deltaLat/2, originalCenterCoordinate.longitude);
        mapView.centerCoordinate = newCenter;
    }
    //se lo spostamento è verso l'alto riduco h mappa, se verso il basso aumento h mappa
    addFloat =  _lastContentOffset-scrollView.contentOffset.y;
    
    NSLog(@"y = %f, last y = %f", scrollView.contentOffset.y, _lastContentOffset);
    NSLog(@"add -> %f",addFloat);
    
    self.mapView.frame = CGRectMake(0, 0, mapFrame.size.width, mapFrame.size.height+addFloat);
    _lastContentOffset = scrollView.contentOffset.y;
    
}

@end
