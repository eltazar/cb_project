//
//  TurismoTableViewController.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "TurismoTableViewController.h"
#import "AreaTurismoItemCell.h"
#import "CustomSpinnerView.h"
#import "ErrorView.h"
#import "Reachability.h"


@interface TurismoTableViewController () {
    CustomSpinnerView *_spinner;
    ErrorView *_errorView;
}
@end


@implementation TurismoTableViewController

#pragma mark - View Lifecicle



- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    /*self.areaTurismoSection = [[AreaTurismoSection alloc] init];
    self.areaTurismoSection.sectionId = self*/
    self.areaTurismoSection.delegate = self;
    [self.areaTurismoSection fetchData];
    
    _spinner = [[CustomSpinnerView alloc] initWithFrame:self.view.frame];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    [self fetchData];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    if(_errorView && _errorView.showed){
        [_errorView removeFromSuperview];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"AreaTurismoItemCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AreaTurismoItemCell" owner:self options:NULL] objectAtIndex:0];
        UIView *v = [[UIView alloc] init];
        v.opaque = YES;
        v.backgroundColor = [UIColor colorWithRed:194/255.0f green:203/255.0f blue:219/255.0f alpha:1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = v;
    }
    ((AreaTurismoItemCell *)cell).areaTurismoItem = [_dataModel valueForKey:@"ITEM" atIndexPath:indexPath];
    return cell;
}



#pragma mark - Table view delegate



/*- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1]];
}*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
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
    }*/
    
}



#pragma mark - Private methods



- (void)setupBackgroundView {
    
}


- (void)showData {
    //rimuovo e fermo spinner
    [_spinner removeFromSuperview];
    [_spinner stopAnimating];
    
    //creo oggetto area ed ottengo il model da esso
    _dataModel = [self.areaTurismoSection getDataModel];
    self.tableView.dataSource = _dataModel;
    _dataModel.cellFactory = self;
    [self.tableView reloadData];
}



#pragma mark - CachedAsyncImageDelegate



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
    NSLog(@"didReceiveBusinessLogicData");
    [self showData];
}


- (void)didReceiveBusinessLogicDataError:(NSString *)error {
    [self stopSpinner];
    [self showErrorView:error];
}



#pragma mark - ErrorView methods



- (void)stopSpinner{
    [_spinner stopAnimating];
    [_spinner removeFromSuperview];
}


- (void)showErrorView:(NSString*)message {
    if(_errorView && _errorView.showed){
        return;
    }

    _errorView = [[ErrorView alloc] init];

    _errorView.label.text = message;
    [_errorView.tapRecognizer addTarget:self action:@selector(hideErrorView:)];
    
    CGRect oldFrame = [_errorView frame];
    [_errorView setFrame:CGRectMake(0, 43, oldFrame.size.width, 0)];
    
    [self.navigationController.view addSubview:_errorView];
    
    [UIView animateWithDuration:0.5
                     animations:^(void){
                         [_errorView setFrame:CGRectMake(0, 43, oldFrame.size.width, oldFrame.size.height)];
                     }
     ];
    _errorView.showed = YES;
}


- (void)hideErrorView:(UITapGestureRecognizer*)gesture {
    if(_errorView || _errorView.showed){
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             [_errorView setFrame:CGRectMake(0, 43, _errorView.frame.size.width,0)];
                         }
                         completion:^(BOOL finished){
                             //riprovo query quando faccio tap su riprova
                             [self fetchData];
                         }
         ];
        _errorView.showed = NO;
    }
}



#pragma mark - Public Methods



- (void)fetchData {
    //Lancio spinner
    [_spinner startAnimating];
    //aggiungo spinner alla view
    [self.tableView.backgroundView addSubview:_spinner];
    [self.areaTurismoSection fetchData];
}



@end
