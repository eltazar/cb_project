//
//  ContattiViewController_iPhone.m
//  ClubMedici
//
//  Created by mario greco on 29/01/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "ContattiViewController_iPhone.h"

#define CONTENT_OFFSET (self.tableView.frame.size.height - self.tableView.contentSize.height)
@interface ContattiViewController_iPhone ()
{
    CGFloat _lastContentOffset;
    CGRect mapOriginalFrame;
    CLLocationCoordinate2D originalCenterCoordinate;
    CGFloat deltaLatFor1px;
    BOOL isTableVisible;
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
    
    isTableVisible = YES;
    
    /*settaggi grafici della tabella
     */
    tableView.tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_contatti"]];
    tableView.backgroundColor = [UIColor clearColor];
    
    //NSLog(@"contentsize = %f \n Differenza(h-contentSize) = %f",self.tableView.contentSize.height,CONTENT_OFFSET);
    
    /*settaggio mapview per far seguire il centro della mappa con lo scrolling della tab.
     Cosi la mappa mantiene il focus su una certa zona.
     http://stackoverflow.com/questions/10979323/new-foursquare-venue-detail-map
     */
    
    //Tableview gesture recognizer
    UITapGestureRecognizer *tapTable = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTable:)];
    UITapGestureRecognizer *tapMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTable:)];
    tapMap.delegate = self;
    [self.tableView addGestureRecognizer:tapTable];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //***nota: bisogna aspettare che la tab sia popolata prima di calcolare i giusti valori di offset
    
    //content offset: da dove inizia il contenuto della tabella
     self.tableView.contentOffset = CGPointMake(0,-CONTENT_OFFSET);
    //content inset: da dove inizia lo scrolling
    self.tableView.contentInset = UIEdgeInsetsMake(CONTENT_OFFSET, 0, 0, 0);
    //iniziallizzazione dell'offeset per la scrollview
    _lastContentOffset = - CONTENT_OFFSET;
}

-(void)viewDidAppear:(BOOL)animated{
    
    self.mapView.frame = CGRectMake(0, 0, 320, 250);
    [self configureMap];
    mapView.alpha = 0.0;
    [UIView animateWithDuration:0.3
                    animations:^(void){
                        mapView.alpha = 1.0;
                        [self configureMap];
                        [self.view insertSubview:mapView belowSubview:tableView];
                    }
     ];
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return NO;
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
    
    
    //NSLog(@"content offset y = %f ; inset top = %f", tableView.contentOffset.y, self.tableView.contentInset.top);
    CGRect mapFrame = self.mapView.frame;

    CGFloat addFloat;    
    
    //set the frame of MKMapView based on scrollView.contentOffset and make sure the pin is at center of the map view
    if(scrollView.contentOffset.y < 0){
        double deltaLat = scrollView.contentOffset.y*deltaLatFor1px;
        //Move the center coordinate accordingly
        CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(originalCenterCoordinate.latitude-deltaLat/2, originalCenterCoordinate.longitude);
        mapView.centerCoordinate = newCenter;
    }
    //se lo spostamento è verso l'alto riduco h mappa, se verso il basso aumento h mappa
    addFloat =  _lastContentOffset-scrollView.contentOffset.y;
    
    //NSLog(@"y = %f, last y = %f", scrollView.contentOffset.y, _lastContentOffset);
    //NSLog(@"add -> %f",addFloat);
    
    self.mapView.frame = CGRectMake(0, 0, mapFrame.size.width, mapFrame.size.height+addFloat);
    _lastContentOffset = scrollView.contentOffset.y;

}

#pragma mark - Gesture methods

-(void) hideTable:(UITapGestureRecognizer*)tap{
    
    CGPoint point = [tap locationInView:self.view];
    
    if(isTableVisible){
        if(point.y <= CONTENT_OFFSET+self.tableView.tableHeaderView.frame.size.height){
            //nascondo tabella
            CGFloat paddingDown = -(CONTENT_OFFSET+self.tableView.contentSize.height-self.tableView.tableHeaderView.frame.size.height);
            [UIView animateWithDuration:0.2
                             animations:^(void){
                                 self.tableView.contentOffset = CGPointMake(0,paddingDown);
                             }
             ];
            isTableVisible = NO;
                [self.tableView setUserInteractionEnabled:NO];
            [self showCloseButton];
        }
    }
    else{
        
        
        if(point.y >= tableView.frame.size.height-tableView.tableHeaderView.frame.size.height){
            //mostro tabella
            [self showTableView];
            [self removeCloseButton];

        }
    }
}


#pragma mark - Gesture recognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - metodi privati

-(void) configureMap{
    [self.mapView setUserInteractionEnabled:YES];
    self.mapView.region = [self centerMap];
    CLLocationCoordinate2D referencePosition = [mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:mapView];
    CLLocationCoordinate2D referencePosition2 = [mapView convertPoint:CGPointMake(0, 100) toCoordinateFromView:mapView];
    deltaLatFor1px = (referencePosition2.latitude - referencePosition.latitude)/100;
}
-(MKCoordinateRegion)centerMap{
    originalCenterCoordinate = CLLocationCoordinate2DMake(41.871940, 12.567380);
    mapView.centerCoordinate = originalCenterCoordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(5,5);
    MKCoordinateRegion region = MKCoordinateRegionMake(originalCenterCoordinate, span);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:region];
    return adjustedRegion;
}

-(void)removeCloseButton{
    self.navigationItem.rightBarButtonItem = nil;
}
-(void)showCloseButton{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Chiudi" style:UIBarButtonItemStylePlain target:self action:@selector(showTableView)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

-(void)showTableView{
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationItem setHidesBackButton:NO animated:YES];
    CGFloat paddingUp = self.tableView.contentOffset.y+self.tableView.contentSize.height-self.tableView.tableHeaderView.frame.size.height;
    [UIView animateWithDuration:0.2
                     animations:^(void){
                         self.tableView.contentOffset = CGPointMake(0,paddingUp);
                     }
     ];
    isTableVisible = YES;
    [tableView setUserInteractionEnabled:YES];
    [self configureMap];
}
@end
