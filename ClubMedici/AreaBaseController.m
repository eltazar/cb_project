//
//  AreaBaseControllerViewController.m
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>

#import "AreaBaseController.h"
#import "AreaDescriptionCell.h"
#import "AreaBase.h"
#import "PDFviewerController.h"
#import "WMTableViewDataSource.h"
#import "CachedAsyncImageView.h"
#import "AreeEnum.h"
#import "DocumentoAreaController.h"
#import "FXLabel.h"
#import "CustomSpinnerView.h"
#import "Reachability.h"

#define QUERY_TIME_LIMIT 10//3600

@interface AreaBaseController () {
    NSDate *dateDoneQuery;
    CustomSpinnerView *spinner;
}
@end

@implementation AreaBaseController
@synthesize area, areaId;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    
    //self.title = [self.area titolo];
                                        
    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    imageView = [[CachedAsyncImageView alloc] init];
    imageView.delegate = self;
    [imageView setCustomPlaceholder:@"placeholder.jpg"];
    [self setupBackgroundView];
    
    //il controller figlio di questo controller avrà il titolo del back Button personalizzato
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Indietro" style:UIBarButtonItemStyleBordered target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
    
    dateDoneQuery = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"queryDate%@",[self getAreaType]]];
    //Position the activity image view somewhere in
    //the middle of your current view
    spinner = [[CustomSpinnerView alloc] initWithFrame:self.view.frame];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    [self fetchData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
        
    if(indexPath.section == 0){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:NULL] objectAtIndex:0];
        }
        
        FXLabel *contactLabel = (FXLabel *) [cell viewWithTag:1];
        contactLabel.shadowColor = [UIColor colorWithWhite:1 alpha:1];
        contactLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        contactLabel.shadowBlur = 1.0f;
        contactLabel.innerShadowBlur = 3.0f;
        contactLabel.innerShadowColor = [UIColor colorWithRed:22/255.0f green:47/255.0f blue:156/255.0f alpha:1];
        contactLabel.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
        contactLabel.highlightedTextColor =[UIColor blackColor];

        UIImageView *img = (UIImageView *)[cell viewWithTag:2];
        
        if([dataKey isEqualToString:@"pdf"]){
            [img setImage:[UIImage imageNamed:@"pdfImage"]];  
        }
        else if([dataKey isEqualToString:@"phone"]){
            [img setImage:[UIImage imageNamed:@"phone"]];
            contactLabel.text = @"Telefono";
        }
        else if([dataKey isEqualToString:@"email"]){
            [img setImage:[UIImage imageNamed:@"mail"]];
            contactLabel.text = @"E-mail";
        }
        else{
            [img setImage:nil];
        }

    //    CAGradientLayer *gradient = [CAGradientLayer layer];
    //    gradient.frame = cell.bounds;
    //    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor]CGColor], (id)[[UIColor colorWithRed:217/255.0f green:234/255.0f blue:254/255.0f alpha:1]CGColor], nil];
    //    gradient.startPoint = CGPointMake(0.5f, 0.0f);
    //    gradient.endPoint = CGPointMake(0.5f, 1.0f);
    //    [bgview.layer addSublayer:gradient];
        // At end of function, right before return cell:
        //cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ActionCell" owner:self options:NULL] objectAtIndex:0];
        }
    }
    
    /*Testo della cella*/
    
    FXLabel *label = (FXLabel *) [cell viewWithTag:3];
    label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    label.shadowOffset = CGSizeMake(1.0f, 1.0f);
    label.shadowBlur = 1.0f;
    label.innerShadowBlur = 3.0f;
    label.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
    label.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
    label.highlightedTextColor =[UIColor blackColor];
    label.text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
    
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
    
    /*Background della cella*/
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview.opaque = YES;
    bgview.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];//[UIColor whiteColor];
    [cell setBackgroundView:bgview];
    
    
    return cell;
}


#pragma mark - Table view delegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    NSLog(@"CHIAMATO = %d",[tableView.dataSource numberOfSectionsInTableView:tableView]);
//    if ([tableView.dataSource numberOfSectionsInTableView:tableView] == 0) {
//        return 0;
//    } else {
//        return [super tableView:tableView heightForHeaderInSection:section];
//    }
//}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_dataModel tableView:tableView titleForHeaderInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if([dataKey isEqualToString:@"documentoArea"]){
        //NSLog(@"DOCUMENTO AREA CLICCATO = %@",[_dataModel valueForKey:@"ID_PAG" atIndexPath:indexPath]);
        DocumentoAreaController *descController = [DocumentoAreaController idiomAllocInit];
        descController.idPag = [_dataModel valueForKey:@"ID_PAG" atIndexPath:indexPath];
        descController.title = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
        [self.navigationController pushViewController:descController animated:YES];
    }
    else if ([dataKey isEqualToString:@"phone"]) {
        NSLog(@"numero di telefono = %@",
              [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath]);
        [self callNumber: [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath]];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([dataKey isEqualToString:@"pdf"]) {
        NSString *title = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
        PDFviewerController *pdfViewer = [[PDFviewerController alloc]initWithTitle:title                                                                      url:nil];
        [self.navigationController presentViewController:pdfViewer animated:YES completion:nil];
    }
    else if ([dataKey isEqualToString:@"email"]) {
        [self sendEmail:[_dataModel valueForKey:@"LABEL" atIndexPath:indexPath]];
    }
    
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    CustomHeader *header = [[CustomHeader alloc] init] ;
//    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
//    return header;
//}
//
//-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 25;
//}


#pragma mark - Private methods


-(void)sendEmail:(NSString*) mail{
    [Utilities sendEmail:mail controller:self];
}

-(void)callNumber:(NSString*)number{
    [Utilities callNumber:number];
}

#pragma mark - MFMailComposeViewControllerDelegate


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissModalViewControllerAnimated:YES];
    if(result == MFMailComposeResultSent) {
        NSLog(@"messaggio inviato");
    }
	else if (result == MFMailComposeResultFailed){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messaggio non inviato!" message:@"Non è stato possibile inviare la tua e-mail" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil];
		[alert show];
	}
    else if (result == MFMailComposeResultCancelled){
        NSLog(@"messaggio annullato");
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}


#pragma mark - Private methods

- (void)setupBackgroundView {

}

-(NSString*)getAreaType{
    NSString *a;
    switch (areaId) {
        case AreaFinanziaria:
            a = @"AreaFinanziaria";
            break;
        case AreaAssicurativa:
            a = @"AreaAssicurativa";
            break;
        case AreaCureMediche:
            a = @"AreaCureMediche";
            break;
        case AreaLeasing:
            a = @"AreaLeasing";
            break;
        case AreaTurismo:
            a = @"AreaTurismo";
            break;
        default:
            break;
    }
    return a;
}

-(void)showData{
    
    //rimuovo e fermo spinner
    [spinner removeFromSuperview];
    [spinner stopAnimating];
    
    //creo oggetto area ed ottengo il model da esso
    _dataModel = [self.area getDataModel];
    self.tableView.dataSource = _dataModel;
    _dataModel.cellFactory = self;
    [self.tableView reloadData];
    if(self.area.img)
        [imageView loadImageFromURLString:self.area.img];
    else
        [imageView setCustomPlaceholder:@"placeholder.jpg"];
}

#pragma mark - CachedAsyncImageDelegate
-(void)didFinishLoadingImage:(id)sender{
    
    //NSLog(@"SCARICATA IMMAGINE IN AREA CONTROLLER");
    [self.tableView.backgroundView addSubview:imageView];
}

-(void)didErrorLoadingImage:(id)sender{
    //TODO: riprovare a fare il download dell'immagine in automatico?
    NSLog(@"Errore download cachedImg in area base controller");
}

#pragma mark - WMHTTPAccessDelegate

-(void) fetchData{
    
    if([Utilities networkReachable]){
        //Lancio spinner
        [spinner startAnimating];
        //aggiungo spinner alla view
        [self.tableView.backgroundView addSubview:spinner];
        
        //se è passato il limite di tempo per la query, fai la query
        NSLog(@"DATA QUERY = %@",dateDoneQuery);
        if([dateDoneQuery timeIntervalSinceDate:[NSDate date]]== 0.0 ||
           (-[dateDoneQuery timeIntervalSinceDate:[NSDate date]]) >= QUERY_TIME_LIMIT){
            
            NSLog(@"\n///**** \n FACCIO LA QUERY \n ///*****");
            //è tempo di fare la query
            [PDHTTPAccess getAreaContents:areaId delegate:self];
        }
        else{
             NSLog(@"\n///**** \n RECUPERO JSON SALVATO \n ///*****");
            //se precedemente scaricate mostra le previsioni salvate
            self.area = [Utilities loadCustomObjectWithKey:[self getAreaType]];
            [self showData];
        }
    }
    else{
        [self showErrorView:@"Connessione assente"];
    }
}

-(void)didReceiveJSON:(NSArray *)jsonArray{
    //NSLog(@"JSON = %@",jsonArray);
    
    Class areaClass = NSClassFromString([self getAreaType]);
    self.area = [[areaClass alloc] initWithJson:jsonArray];
    
    [self showData];
    
    //salvo ora in cui ho ricevuto l'oggetto e l'oggetto
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    dateDoneQuery = [NSDate date];
    [pref setObject:dateDoneQuery forKey:[NSString stringWithFormat:@"queryDate%@",[self getAreaType]]];
    [pref synchronize];
    //salvo json ricevuto
    [Utilities saveCustomObject:self.area key:[self getAreaType]];
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"ERRORE = %@",[error description]);
    [self showErrorView:@"Errore server"];
}

- (void) networkStatusChanged:(NSNotification*) notification
{
	Reachability* reachability = notification.object;
    NSLog(@"*** AreaBaseController: network status changed ***");
	if(reachability.currentReachabilityStatus == NotReachable){
		NSLog(@"Internet off");
        [self showErrorView:@"Connessione assente"];
    }
	else{
		NSLog(@"Internet on");
        [self hideErrorView:nil];
    }
}

#pragma mark - ErrorView methods
-(void)hideErrorView:(UITapGestureRecognizer*)gesture{
}

-(void)showErrorView:(NSString*)message{
}

@end
