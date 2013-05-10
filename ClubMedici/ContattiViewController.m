//
//  ContattiViewController.m
//  ClubMedici
//
//  Created by mario greco on 29/01/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "ContattiViewController.h"
#import "FXLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "WebViewCell.h"
#import "UIViewController+InterfaceIdiom.h"
#import "AreaDescriptionCell.h"

@interface ContattiViewController ()
{
    AreaDescriptionCell *companyDescriptionCell;
}
@end

@implementation ContattiViewController
@synthesize mapView;
@synthesize tableView;

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
    self.tableView.dataSource = _dataModel;
    _dataModel.cellFactory = self;
    _dataModel.showSectionHeaders = NO;

    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    sediPin = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];
    
    //alloco descrizione cell
    NSString *nibName = IDIOM_SPECIFIC_STRING(@"AreaDescriptionCell");
    companyDescriptionCell = [[[NSBundle mainBundle] loadNibNamed:nibName
                                              owner:nil
                                            options:nil] objectAtIndex:0];
    
    [Utilities logEvent:@"Sezione_contatti_visitata" arguments:nil];
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
}

-(void)viewWillDisappear:(BOOL)animated{
    self.mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [mapView addAnnotations:sediPin];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];

    if([dataKey isEqualToString:@"company"]){
        static NSString *CellIdentifier = @"WebViewCell";
        cell = (WebViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[WebViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        
        UIWebView *webView =(UIWebView*) [cell viewWithTag:3];
        NSString *htmlPage = @"<html><head><style type=\"text/css\">%@</style></head><body>%@</body></html>";
        NSString *style = @"body {margin:10px 20px 0px;background-color: #f6faff;}p,strong {line-height: 14px;font-size: 15px;font-family:helvetica;color: #333333;text-shadow: #fff 0px 1px 0px;}";
        [webView setBackgroundColor:[UIColor clearColor]];
        [webView setOpaque:NO];
        htmlPage = [NSString stringWithFormat:htmlPage,style,[_dataModel valueForKey:@"LABEL" atIndexPath:indexPath]];
        [webView loadHTMLString:htmlPage baseURL:nil];
        
        
        return cell;
    }
    else if([dataKey isEqualToString:@"aboutUs"]){
        companyDescriptionCell.collapsedHeight = companyDescriptionCellCollapsedHeight;
        companyDescriptionCell.text = @"Club Medici è l'associazione per Medici Chirurghi e Odontoiatri iscritti agli Albi Provinciali. Da venti anni, Club Medici è il punto di riferimento dei medici per tutte le esigenze della vita quotidiana e del tempo libero. Il Club Medici offre ai suoi associati una vasta gamma di servizi nelle sue aree di attività: Area Finanziaria, Area Assicurativa e Area Turismo. E in più: eventi e cultura! ";

        return companyDescriptionCell;
    }
    else{
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:NULL] objectAtIndex:0];
            UIView *v = [[UIView alloc] init];
            v.backgroundColor = [UIColor colorWithRed:194/255.0f green:203/255.0f blue:219/255.0f alpha:1];
            cell.selectedBackgroundView = v;
        }
    //    cell.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];
        
        UIImageView *img = (UIImageView *)[cell viewWithTag:2];

        FXLabel *label   = (FXLabel*)    [cell viewWithTag:3];
        label.textColor = [UIColor colorWithWhite:0.5f alpha:1];
        label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
        label.shadowOffset = CGSizeMake(0.8f, 0.80f);
        label.shadowBlur = 1.0f;
        label.innerShadowBlur = 3.0f;
        label.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
        label.innerShadowOffset = CGSizeMake(0.8f, 0.8f);
        label.highlightedTextColor =[UIColor blackColor];
        
        //NSLog(@"LABEL = %@",[_dataModel valueForKey:@"LABEL" atIndexPath:indexPath]);
        label.text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
        
        FXLabel *contactLabel = (FXLabel *) [cell viewWithTag:1];
        contactLabel.textColor = [UIColor colorWithRed:11/255.0f green:67/255.0f blue:144/255.0f alpha:1];
        contactLabel.highlightedTextColor =[UIColor blackColor];
        
        /* Linea separatrice tra le celle*/
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //bordo inferiore da applicare alla linea
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, 0.0f,1024, 1.5f);
        bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
        
        //linea separatrice alta 1px, posizionata alla base inferiore della cella
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 1024, 1)];
        separatorView.layer.borderColor = [UIColor colorWithRed:214/255.0f green:226/255.0f blue:241/255.0f alpha:1].CGColor;
        separatorView.layer.borderWidth = 1.0;
        //applico bordo inferiore
        [separatorView.layer addSublayer:bottomBorder];
        //applico linea alla cella
        [cell.contentView addSubview:separatorView];
        
        /*Fine linea separatrice*/
        
        //immagini
        
        if([dataKey isEqualToString:@"phone"]){
            [img setImage:[UIImage imageNamed:@"phone2"]];
            contactLabel.text = @"Telefono";
        }
        else if([dataKey isEqualToString:@"mail"]){
            [img setImage:[UIImage imageNamed:@"mail2"]];
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
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //[cell setBackgroundColor:[UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1]];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_dataModel tableView:tableView titleForHeaderInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    if([dataKey isEqualToString:@"facebook"]){
        NSURL *url = [NSURL URLWithString:@"fb://profile/110555735629242"];
        [[UIApplication sharedApplication] openURL:url];
        
        if (![[UIApplication sharedApplication] openURL: url]) {
            //fanPageURL failed to open.  Open the website in Safari instead
            NSURL *webURL = [NSURL URLWithString:@"http://www.facebook.com/pages/CLUB-MEDICI/110555735629242"];
            [[UIApplication sharedApplication] openURL: webURL];
        }
    }
    else if([dataKey isEqualToString:@"twitter"]){
        NSURL *url = [NSURL URLWithString:@"twitter://user?screen_name=Clubmedici"];
        if (![[UIApplication sharedApplication] openURL: url]) {
            //fanPageURL failed to open.  Open the website in Safari instead
            NSURL *webURL = [NSURL URLWithString:@"https://twitter.com/Clubmedici"];
            [[UIApplication sharedApplication] openURL: webURL];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    if ([dataKey isEqualToString:@"aboutUs"]) {
        id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        if ([cell respondsToSelector:@selector(getHeight)])
            return [cell getHeight];
    }
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
