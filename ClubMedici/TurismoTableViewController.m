//
//  TurismoTableViewController.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "TurismoTableViewController.h"
#import "AreaTurismoItemCell.h"
#import "UIViewController+InterfaceIdiom.h"
#import "CustomSpinnerView.h"
#import "ErrorView.h"
#import "Reachability.h"
#import "UIViewController+InterfaceIdiom.h"
#import "DocumentoAreaController.h"

@interface TurismoTableViewController () {
    CustomSpinnerView *_spinner;
    ErrorView *_errorView;
    UISegmentedControl *_segmentedControl;
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
    self.areaTurismoSection.delegate = self;
    
    _dataModelItaly  = [self.areaTurismoSection getDataModelItaly];
    _dataModelAbroad = [self.areaTurismoSection getDataModelAbroad];
    _dataModelItaly .cellFactory = self;
    _dataModelAbroad.cellFactory = self;
    _dataModelItaly.showSectionHeaders = NO;
    _dataModelAbroad.showSectionHeaders = NO;
    self.tableView.dataSource = _dataModelItaly;
    
    _spinner = [[CustomSpinnerView alloc] initWithFrame:self.view.frame];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Italia", @"Estero"]];
    [_segmentedControl setSelectedSegmentIndex:0];
    _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [_segmentedControl addTarget:self
                          action:@selector(segmentedControlChanged)
                forControlEvents:UIControlEventValueChanged];
    if (iPadIdiom()) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithCustomView:_segmentedControl];
    }
    else {
        _segmentedControl.frame = CGRectMake(0, 0, 300, 30);
        self.navigationItem.prompt = self.title;
        self.navigationItem.titleView = _segmentedControl;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    [self fetchData];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    if( _errorView && _errorView.showed) {
        [_errorView removeFromSuperview];
    }
}

//ios5 rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return NO;
    
    return YES;
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
    ((AreaTurismoItemCell *)cell).areaTurismoItem = [(WMTableViewDataSource *)self.tableView.dataSource valueForKey:@"ITEM" atIndexPath:indexPath];
    NSLog(@"indexPath: %@", indexPath);
    return cell;
}



#pragma mark - Table view delegate



/*- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1]];
}*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AreaTurismoItem *item =
        [(WMTableViewDataSource *)self.tableView.dataSource valueForKey:@"ITEM"
                                                            atIndexPath:indexPath];
    DocumentoAreaController *docAreaController = [DocumentoAreaController idiomAllocInit];
    docAreaController.turismoItem = item;
    [self.navigationController pushViewController:docAreaController animated:YES];
}



#pragma mark - CachedAsyncImageDelegate



- (void)didErrorLoadingImage:(id)sender {
    //TODO: riprovare a fare il download dell'immagine in automatico?
    NSLog(@"Errore download cachedImg in area base controller");
}


- (void)networkStatusChanged:(NSNotification*) notification {
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
    NSLog(@"TurismoTableViewControllerDidReceiveBusinessLogicData");
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

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        _errorView = [[ErrorView alloc] initWithSize:self.view.frame.size];
    }
    else _errorView = [[ErrorView alloc] init];

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


- (void)segmentedControlChanged {
    switch(_segmentedControl.selectedSegmentIndex) {
        case 0:
            self.tableView.dataSource = _dataModelItaly;
            break;
        
        case 1:
            self.tableView.dataSource = _dataModelAbroad;
            break;
    }
    [self.tableView reloadData];
}



#pragma mark - Private methods



- (void)setupBackgroundView {
    
}


- (void)showData {
    //rimuovo e fermo spinner
    [_spinner removeFromSuperview];
    [_spinner stopAnimating];
    
    [self.tableView reloadData];
}


    
    
@end
