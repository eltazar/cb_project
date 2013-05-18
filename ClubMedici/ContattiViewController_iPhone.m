//
//  ContattiViewController_iPhone.m
//  ClubMedici
//
//  Created by mario greco on 29/01/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "ContattiViewController_iPhone.h"
#import "MapCell.h"
#import "WebViewCell.h"

#define CONTENT_OFFSET (self.tableView.frame.size.height - self.tableView.contentSize.height)
@interface ContattiViewController_iPhone ()
{
    NSString *phoneNumber;
    
    //nuovi
    BOOL isMapVisible;
    CGPoint _oldContentOffset;
    MapCell *mapCell;
    Sede *sedeNazionale;
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
    _dataModel = [[WMTableViewDataSource alloc] initWithPList:@"Contatti"];
    
    /*settaggi grafici della tabella
     */
    
    _oldContentOffset = CGPointZero;
    isMapVisible = NO;
    
    //alloco map cell
    mapCell = [[MapCell alloc] init];
    

    companyDescriptionCellCollapsedHeight = 90;
    
    [super viewDidLoad];
    
    NSArray *sedi = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Sedi" ofType:@"plist"]];
    
    for(NSDictionary *o in sedi){
        CLLocationCoordinate2D c = CLLocationCoordinate2DMake([[o objectForKey:@"LAT"] floatValue],[[o objectForKey:@"LONG"]floatValue]);
        Sede *s = [[Sede alloc] initWithCoordinate:c];
        [o objectForKey:@"LAT"];
        s.name = [o objectForKey:@"NAME"];
        s.city = [o objectForKey:@"CITY"];
        s.address = [o objectForKey:@"ADDRESS"];
        [sediPin addObject:s];
    }
    sedeNazionale = [sediPin objectAtIndex:0];
    
    mapView = mapCell.mapView;
    [mapView addAnnotations:sediPin];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self.mapView removeAnnotations:[self.mapView annotations]];
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    static int x = 0;
    if([dataKey isEqualToString:@"map"]){   
        self.mapView =(MKMapView*) [mapCell viewWithTag:1];
//        mapView.delegate = self;
//        if (x==0){
//            [mapView removeAnnotations:sediPin];
//            [mapView addAnnotations:sediPin];
//            x++;
//        }
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(sedeNazionale.coordinate, 200000, 200000);
        [mapCell setMapCenter:viewRegion];

        return mapCell;
    }
    else cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];

    if(!isMapVisible){
        if([dataKey isEqualToString:@"map"]){
            [self showMap:indexPath];    
        }
        if([dataKey isEqualToString:@"phone"]){
            phoneNumber = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
            [self callNumber: phoneNumber];
        }
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];

    if([dataKey isEqualToString:@"company"])
        return 92;
    else if([dataKey isEqualToString:@"map"]){
        
        MapCell *cell = (MapCell*)[self tableView: tableView cellForRowAtIndexPath: indexPath];
        return cell.frame.size.height;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        //nslog(@"CHIAMA = %@", phoneNumber);
        [Utilities callNumber:[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""] ];
    }
}

#pragma mark - metodi privati

-(void)credits:(id)sender{
    CreditsViewController *c = [[CreditsViewController alloc] initWithNibName:@"CreditsViewController" bundle:nil];
    [self.navigationController pushViewController:c animated:YES];
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
    
    //nslog(@"MOSTRO TABELLA");
    
    isMapVisible = NO;
    self.tableView.scrollEnabled = YES;
    self.navigationItem.rightBarButtonItem = nil;
    
    for (NSObject<MKAnnotation> *annotation in [mapView selectedAnnotations]) {
        [mapView deselectAnnotation:(id <MKAnnotation>)annotation animated:NO];
    }
    
    [UIView animateWithDuration:.25f
                     animations:^(void){
                         self.tableView.contentOffset = _oldContentOffset;
                     }
     ];
    MapCell * cell = (MapCell*)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [cell setMapEnabled:NO];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(sedeNazionale.coordinate, 200000, 200000);
    [cell setMapCenter:viewRegion];
    
    //Rimostro info button
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(credits:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setRightBarButtonItem:modalButton animated:YES];
    
}

-(void)showMap:(NSIndexPath*)indexPath{
    //nslog(@"MOSTRO MAPPA");
    
    isMapVisible = YES;
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    //dove ha origine la cella all'interno della view
    CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    MapCell *cell = (MapCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    //salvo vecchio content offset
    _oldContentOffset = self.tableView.contentOffset;
    
    //sposto content offset in modo che la mappa inizi dall'inizio della view
    [UIView animateWithDuration:.25f
                     animations:^(void){
                         self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y+rectInSuperview.origin.y);
                     }
     ];
    
    //cambio altezza frame cella, in automatico aumenta il contentView frame anche
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //setto altezza mappa, non più necessario perchè la mappa ha l'autoresize in altezza
    //[cell setMapFrame:cell.frame];
    
    //fa si che la tabella ricalcoli l'altezza degli elementi della sezione senza allocare di nuovo le celle
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(sedeNazionale.coordinate, 1000000, 1000000);
    [cell setMapCenter:viewRegion];
    [cell.mapView selectAnnotation:sedeNazionale animated:YES];
    
    //usando reload invece ricrea oggetti!!!
    //[self.tableView reloadData]; 
    
    //abilito touch sulla mappa
    [cell setMapEnabled:YES];
    //blocco scroll tabella, questo però permette ancora alle celle di essere tapate :S
    self.tableView.scrollEnabled = NO;
    [self showCloseButton];
}

#pragma mark - ActionMethods
- (void)callNumber:(NSString*)number {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Chiamare %@ ?",number] message:nil delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"Chiama", nil];
    [alert show];
}


@end
