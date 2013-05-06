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



@interface AreaBaseController () {
    NSDate *dateDoneQuery;
    //CustomSpinnerView *spinner;
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
    self.area = [[areaClass alloc] init];
    self.area.delegate = self;
    self.area.areaID = self.areaId;
  
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1/255.0f green:70/255.0f blue:148/255.0f alpha:1];
    
    //self.title = [self.area titolo];
                                        
    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //il controller figlio di questo controller avrà il titolo del back Button personalizzato
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Indietro" style:UIBarButtonItemStyleBordered target:nil action:nil];
    //    self.navigationItem.backBarButtonItem = backButton;
    
    //Position the activity image view somewhere in
    //the middle of your current view
    spinner = [[CustomSpinnerView alloc] initWithFrame:self.view.frame];
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
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:NULL] objectAtIndex:0];
            UIView *v = [[UIView alloc] init];
            v.opaque = YES;
            v.backgroundColor = [UIColor colorWithRed:194/255.0f green:203/255.0f blue:219/255.0f alpha:1];
            cell.selectedBackgroundView = v;
        }
        cell.opaque = YES;
        
        FXLabel *contactLabel = (FXLabel *) [cell viewWithTag:1];
        contactLabel.textColor = [UIColor colorWithRed:1/255.0f green:70/255.0f blue:148/255.0f alpha:1];
        //contactLabel.textColor = [UIColor colorWithWhite:0.09f alpha:0.8f];
        //contactLabel.highlightedTextColor =[UIColor blackColor];
        //contactLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:0.8f];
        //contactLabel.shadowOffset = CGSizeMake(0.8f, 0.80f);
        //contactLabel.shadowBlur = 1.0f;
        //contactLabel.innerShadowBlur = 3.0f;
        //contactLabel.innerShadowColor = [UIColor colorWithRed:1/255.0f green:70/255.0f blue:148/255.0f alpha:1];
        //
        //contactLabel.innerShadowOffset = CGSizeMake(0.8f, 0.8f);
        contactLabel.highlightedTextColor =[UIColor blackColor];
        
        UIImageView *img = (UIImageView *)[cell viewWithTag:2];
        img.opaque = YES;
        
        if ([dataKey isEqualToString:@"pdf"]) {
            [img setImage:[UIImage imageNamed:@"pdfImage"]];  
        }
        else if ([dataKey isEqualToString:@"phone"]) {
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
        cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ActionCell" owner:self options:NULL] objectAtIndex:0];
            UIView *v = [[UIView alloc] init];
            v.opaque = YES;
            v.backgroundColor = [UIColor colorWithRed:194/255.0f green:203/255.0f blue:219/255.0f alpha:1];
            cell.selectedBackgroundView = v;
        }
    }
    
    /*Testo della cella*/
    FXLabel *label = (FXLabel *) [cell viewWithTag:3];
    label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    label.shadowOffset = CGSizeMake(0.8f, 0.80f);
    label.shadowBlur = 1.0f;
    label.innerShadowBlur = 3.0f;
    label.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
    label.innerShadowOffset = CGSizeMake(0.8f, 0.8f);
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


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if([dataKey isEqualToString:@"documentoArea"]){
        if ([Utilities networkReachable]) {
            //NSLog(@"DOCUMENTO AREA CLICCATO = %@",[_dataModel valueForKey:@"ID_PAG" atIndexPath:indexPath]);
            DocumentoAreaController *descController = [DocumentoAreaController idiomAllocInit];
            descController.idPag = [_dataModel valueForKey:@"ID_PAG" atIndexPath:indexPath];
            descController.title = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
            [self.navigationController pushViewController:descController animated:YES];
        }
        else{
            [self showErrorView:@"Connessione assente"];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
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


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *sectionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sectionHeader"]];
    sectionView.alpha = 0.95;
    
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
    [Utilities sendEmail:mail controller:self];
}


- (void)callNumber:(NSString*)number {
    [Utilities callNumber:number];
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



#pragma mark - AreaDelegate


- (void)didReceiveAreaData {
    NSLog(@"didReceiveAreaData");
    [self showData];
}


- (void)didReceiveAreaDataError:(NSString *)error {
    [self showErrorView:error];
}



#pragma mark - ErrorView methods



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
