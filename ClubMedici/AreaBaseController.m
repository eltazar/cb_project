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
#import "AreaTurismoCell.h"
#import "AreaBase.h"
#import "PDFviewerController.h"
#import "WMTableViewDataSource.h"
#import "CachedAsyncImageView.h"
#import "AreeEnum.h"
#import "DocumentoAreaController.h"
#import "FXLabel.h"
#import "CustomSpinnerView.h"
#import "Reachability.h"

@interface AreaBaseController () {
}
@end

@implementation AreaBaseController
@synthesize area, areaId;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    Class areaClass = NSClassFromString([AreaBase getAreaType:self.areaId]);
    self.area = [[areaClass alloc] initWithAreaId:(int)areaId];
    self.area.delegate = self;
      
    //self.title = [self.area titolo];
                                        
    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //il controller figlio di questo controller avrà il titolo del back Button personalizzato
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Indietro" style:UIBarButtonItemStyleBordered target:nil action:nil];
    //    self.navigationItem.backBarButtonItem = backButton;
    
    //Position the activity image view somewhere in
    //the middle of your current view
    spinner = [[CustomSpinnerView alloc] initWithFrame:self.view.frame];
    spinner.frame = CGRectMake(self.navigationController.navigationBar.frame.size.width/2 - spinner.frame.size.width/2, self.view.frame.size.height/2 - spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
    
    imageView = [[CachedAsyncImageView alloc] init];
    imageView.delegate = self;
    [imageView setCustomPlaceholder:IDIOM_SPECIFIC_STRING(@"background")];
    
    NSString *nibName = IDIOM_SPECIFIC_STRING(@"AreaDescriptionCell");
    _areaDescriptionCell = [[[NSBundle mainBundle] loadNibNamed:nibName
                                                          owner:nil
                                                        options:nil] objectAtIndex:0];
    
    [self setupBackgroundView];
        
    //flurry log
    NSDictionary *articleParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.title, @"Nome_area",
     nil];
    [Utilities logEvent:@"Area_visitata" arguments:articleParams];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    [self fetchData];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    if(errorView && errorView.showed){
        [errorView removeFromSuperview];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    UITableViewCell *cell = nil;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if ([dataKey isEqualToString:@"description"]) {
        // _areaDescriptionCell.backgroundView = [[CustomCellBackground alloc] init];
        // _areaDescriptionCell.selectedBackgroundView = [[CustomCellBackground alloc] init];
        _areaDescriptionCell.collapsedHeight = areaDescriptionCellCollapsedHeight;
        _areaDescriptionCell.text = self.area.descrizione;
        return _areaDescriptionCell;
    }

    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:NULL] objectAtIndex:0];
            UIView *v = [[UIView alloc] init];
            v.opaque = YES;
            v.backgroundColor = [UIColor colorWithRed:144/255.0f green:170/255.0f blue:201/255.0f alpha:1];
            cell.selectedBackgroundView = v;
        }
        cell.opaque = YES;
        
        UILabel *contactLabel = (UILabel *) [cell viewWithTag:1];
        contactLabel.textColor = [UIColor colorWithRed:11/255.0f green:67/255.0f blue:144/255.0f alpha:1];
        contactLabel.highlightedTextColor =[UIColor whiteColor];
        
        UIImageView *img = (UIImageView *)[cell viewWithTag:2];
        img.opaque = YES;

        if ([dataKey isEqualToString:@"phone"]) {
            [img setImage:[UIImage imageNamed:@"phone2"]];
            contactLabel.text = @"Telefono";
        }
        else if ([dataKey isEqualToString:@"email"]) {
            [img setImage:[UIImage imageNamed:@"mail2"]];
            contactLabel.text = @"E-mail";
        }
        else{
            [img setImage:nil];
        }
      
        for(UIView *subview in [cell.contentView subviews]) {
            if(subview.tag== 999) {
                [subview removeFromSuperview];
            }
        }
        //inserisco linea separatrice in top della prima cella
        if(indexPath.row == 1){
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, 0.0f,1024, 1.5f);
            bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
            
            //linea separatrice alta 1px, posizionata alla base inferiore della cella
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
            line.opaque = YES;
            line.tag = 999;
            line.layer.borderColor = [UIColor colorWithRed:214/255.0f green:226/255.0f blue:241/255.0f alpha:1].CGColor;
            line.layer.borderWidth = 1.0;
            //applico bordo inferiore
            [line.layer addSublayer:bottomBorder];
            //applico linea alla cella
            [cell.contentView addSubview:line];
        }
    }
    else {
        if ([dataKey isEqualToString:@"ViaggiTurismo"]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ViaggiTurismo"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"AreaTurismoCell"
                                                      owner:self
                                                    options:NULL] objectAtIndex:0];
            }
            AreaTurismoCell *turismoCell = (AreaTurismoCell *)cell;
            turismoCell.navController = self.navigationController;
            [turismoCell setItems:[_dataModel valueForKey:@"ITEMS" atIndexPath:indexPath]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell; // il return qui ci evita il blocco di stilizzazione
        }

        cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ActionCell"
                                                  owner:self
                                                options:NULL] objectAtIndex:0];
            UIView *v = [[UIView alloc] init];
            v.opaque = YES;
            v.backgroundColor = [UIColor colorWithRed:144/255.0f green:170/255.0f blue:201/255.0f alpha:1];
            cell.selectedBackgroundView = v;
        }
    }
    
    /*Testo della cella*/
    UILabel *label = (UILabel *) [cell viewWithTag:3];
//    label.textColor = [UIColor colorWithWhite:0.5f alpha:1];
//    label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
//    label.shadowOffset = CGSizeMake(0.8f, 0.80f);
//    label.shadowBlur = 1.0f;
//    label.innerShadowBlur = 3.0f;
//    label.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
//    label.innerShadowOffset = CGSizeMake(0.8f, 0.8f);
//    label.highlightedTextColor =[UIColor whiteColor];
    label.text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];

    label.textColor     = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    label.shadowColor   = [UIColor blackColor];
    label.shadowOffset  = CGSizeMake(-0.5,-0.5);

    
    /* Linea separatrice tra le celle*/
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //bordo inferiore da applicare alla linea
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 0.0f,1024, 1.5f);
    bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    
    //linea separatrice alta 1px, posizionata alla base inferiore della cella
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, 1024, 1)];
    separatorView.opaque = YES;
    separatorView.layer.borderColor = [UIColor colorWithRed:214/255.0f green:226/255.0f blue:241/255.0f alpha:1].CGColor;
    separatorView.layer.borderWidth = 1.0;
    //applico bordo inferiore
    [separatorView.layer addSublayer:bottomBorder];
    //applico linea alla cella
    [cell.contentView addSubview:separatorView];
    /*Fine linea separatrice*/   
    
    return cell;
}



#pragma mark - Table view delegate




- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_dataModel tableView:tableView titleForHeaderInSection:section];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if([dataKey isEqualToString:@"documentoArea"]){
        if ([Utilities networkReachable]) {
            //NSLog(@"DOCUMENTO AREA CLICCATO = %@",[_dataModel valueForKey:@"ID_PAG" atIndexPath:indexPath]);
            DocumentoAreaController *descController = [DocumentoAreaController idiomAllocInit];
            descController.docItem = [self.area.itemList objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:descController animated:YES];
        }
        else{
            [self showErrorView:@"Connessione assente"];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    else if ([dataKey isEqualToString:@"pdf"]) {
        NSString *title = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
        PDFviewerController *pdfViewer = [[PDFviewerController alloc]initWithTitle:title                                                                      url:nil];
        [self.navigationController presentViewController:pdfViewer animated:YES completion:nil];
    }
    else if ([dataKey isEqualToString:@"email"]) {
        [self sendEmail:[_dataModel valueForKey:@"LABEL" atIndexPath:indexPath]];
    }
    else if ([dataKey isEqualToString:@"calcolatore"]) {
        NSString *nibName = IDIOM_SPECIFIC_STRING(@"CalcolaRataController");
        CalcolaRataController *calcolaController = [[CalcolaRataController alloc] initWithNibName:nibName bundle:nil];
        [self.navigationController pushViewController:calcolaController animated:YES];
    }

    
}


//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    CustomHeader *header = [[CustomHeader alloc] init] ;
//    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
//    return header;
//}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([dataKey isEqualToString:@"description"] ||
        [dataKey isEqualToString:@"ViaggiTurismo"]) {
        id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        if ([cell respondsToSelector:@selector(getHeight)])
            return [cell getHeight];
    }
    else if(indexPath.section == 0 && indexPath.row > 0){
        return [cell frame].size.height;
    }
    return UITableViewAutomaticDimension;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //sectionView.alpha = 0.95;
    UIImageView *sectionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"area_sec_background"]];

    //Add label to view
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, -9, 320, 40)];
    titleLabel.backgroundColor =[UIColor clearColor];
    [titleLabel setFont: [UIFont fontWithName:@"Helvetica-Bold" size:16.5f ]];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [sectionView addSubview:titleLabel];
    
    return sectionView;
}



#pragma mark - Private methods



- (void)sendEmail:(NSString*) mail {
    [Utilities sendEmail:mail controller:self delegate:self];
}


#pragma mark - MFMailComposeViewControllerDelegate



- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissModalViewControllerAnimated:YES];
    if (result == MFMailComposeResultSent) {
        NSLog(@"messaggio inviato");
    }
	else if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messaggio non inviato!" message:@"Non è stato possibile inviare la tua e-mail" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil];
		[alert show];
	}
    else if (result == MFMailComposeResultCancelled) {
        NSLog(@"messaggio annullato");
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}



#pragma mark - Private methods



- (void)setupBackgroundView {

}


- (void)showData {
    //rimuovo e fermo spinner
    [spinner removeFromSuperview];
    [spinner stopAnimating];
    
    //creo oggetto area ed ottengo il model da esso
    _dataModel = [self.area getDataModel];
    self.tableView.dataSource = _dataModel;
    _dataModel.cellFactory = self;
    [self.tableView reloadData];
    if (self.area.img)
        [imageView loadImageFromURLString:self.area.img];
    else
        [imageView setCustomPlaceholder:@"placeholder.jpg"];
}



#pragma mark - CachedAsyncImageDelegate



- (void)didFinishLoadingImage:(id)sender{ 
    
    //NSLog(@"SCARICATA IMMAGINE IN AREA CONTROLLER");
    [self.tableView.backgroundView addSubview:imageView];
}


- (void)didErrorLoadingImage:(id)sender {
    //TODO: riprovare a fare il download dell'immagine in automatico?
    NSLog(@"Errore download cachedImg in area base controller");
}


- (void) networkStatusChanged:(NSNotification*) notification {
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



#pragma mark - BusinessLogicDelegate


- (void)didReceiveBusinessLogicData {
    NSLog(@"didReceiveAreaData");
   [self showData];
}


- (void)didReceiveBusinessLogicDataError:(NSString *)error {
    [self stopSpinner];
    [self showErrorView:error];
}


#pragma mark - ErrorView methods

-(void)stopSpinner{
    [spinner stopAnimating];
    [spinner removeFromSuperview];
}


- (void)showErrorView:(NSString*)message {
    errorView.label.text = message;
    [errorView.tapRecognizer addTarget:self action:@selector(hideErrorView:)];
    
    CGRect oldFrame = [errorView frame];
    [errorView setFrame:CGRectMake(0, 43, oldFrame.size.width, 0)];
    
    [self.navigationController.view addSubview:errorView];
    
    [UIView animateWithDuration:0.5
                     animations:^(void){
                         [errorView setFrame:CGRectMake(0, 43, oldFrame.size.width, oldFrame.size.height)];
                     }
     ];
    errorView.showed = YES;
}


- (void)hideErrorView:(UITapGestureRecognizer*)gesture {
    if(errorView || errorView.showed){
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             [errorView setFrame:CGRectMake(0, 43, errorView.frame.size.width,0)];
                         }
                         completion:^(BOOL finished){
                             //riprovo query quando faccio tap su riprova
                             [self fetchData];
                         }
         ];
        errorView.showed = NO;
    }
}



#pragma mark - Public Methods



- (void)fetchData {
    //Lancio spinner
    [spinner startAnimating];
    //aggiungo spinner alla view
    [self.tableView.backgroundView addSubview:spinner];
    [self.area fetchData];
}



@end
