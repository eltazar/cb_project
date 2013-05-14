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
#import "FXLabel.h"

#define PORTRAIT_WIDTH 400.0
#define LANDSCAPE_WIDTH 500.0


@interface TurismoTableViewController () {
    CustomSpinnerView *_spinner;
    ErrorView *_errorView;
    UISegmentedControl *_segmentedControl;
    FXLabel *_noDataLabel;
    PullToRefreshView *_pullToRefresh;
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
    //TODO: sistemare sto disastro
    [super viewDidLoad];
    self.areaTurismoSection.delegate = self;
    
    _dataModelItaly  = [self.areaTurismoSection getDataModelItaly];
    _dataModelAbroad = [self.areaTurismoSection getDataModelAbroad];
    _dataModelItaly .cellFactory = self;
    _dataModelAbroad.cellFactory = self;
    _dataModelItaly.showSectionHeaders = NO;
    _dataModelAbroad.showSectionHeaders = NO;
    self.tableView.dataSource = _dataModelItaly;
    
    self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.tableView.contentMode = UIViewContentModeScaleAspectFit;
    _spinner = [[CustomSpinnerView alloc] initWithFrame:self.view.frame];
    _spinner.center = self.tableView.backgroundView.center;//CGRectMake(self.view.frame.size.width / 2 - _spinner.frame.size.width / 2,
                           //self.view.frame.size.height / 2 - _spinner.frame.size.height / 2,
                           //_spinner.frame.size.width,
                           //_spinner.frame.size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:
                              [UIImage imageNamed:IDIOM_SPECIFIC_STRING(@"background")]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    CGFloat imgWidth;
    //if (iPhoneIdiom())
    imgWidth = self.view.frame.size.width;
    /*else {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsPortrait(orientation))
            imgWidth = PORTRAIT_WIDTH;
        else
            imgWidth = LANDSCAPE_WIDTH;
    }*/
    imageView.frame = CGRectMake(0, 0, imgWidth,
                                 (imageView.image.size.height/imageView.image.size.width) * imgWidth);
    //imageView.backgroundColor = [UIColor blackColor];
    //self.tableView.backgroundView.backgroundColor = [UIColor redColor];
    [self.tableView.backgroundView addSubview:imageView];
    NSLog(@"bgview: %@",  NSStringFromCGRect(self.tableView.backgroundView.frame));
    NSLog(@"imgView: %@", NSStringFromCGRect(imageView.frame));
    NSLog(@"img: %@", NSStringFromCGSize(imageView.image.size));
    
    
    /*if (iPadIdiom()) {
        CGFloat scaleFactor = 0.0;
        CGFloat width = 0.0;
        CGFloat height = 0.0;
        
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            scaleFactor = PORTRAIT_WIDTH / imageView.image.size.width;
            width = PORTRAIT_WIDTH;
            height = scaleFactor * imageView.image.size.height;
        }
        else{
            scaleFactor = LANDSCAPE_WIDTH/imageView.image.size.width;
            height = scaleFactor * imageView.image.size.height;
            width = LANDSCAPE_WIDTH;
        }
        
        imageView.frame = CGRectMake(0, 0, width, height);
    }
    else {
        CGFloat tableViewWidth = self.tableView.frame.size.width;
        imageView.frame = CGRectMake(0, 0,
                                     tableViewWidth,
                                     tableViewWidth * (imageView.image.size.height / imageView.image.size.width)
                                     );
    }*/
    
    _noDataLabel = [[FXLabel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height, imageView.frame.size.width, 200)];
    _noDataLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleLeftMargin;
    _noDataLabel.backgroundColor = [UIColor clearColor];
    _noDataLabel.textColor = [UIColor colorWithRed:230.0/255.0
                                             green:230.0/255.0
                                              blue:230.0/255.0 alpha:1.0];
    _noDataLabel.text = @"Non ci sono offerte\ndisponibili\nin questa categoria";
    _noDataLabel.textAlignment = UITextAlignmentCenter;
    _noDataLabel.font = [UIFont boldSystemFontOfSize:iPhoneIdiom()?18.0:25.0];
    _noDataLabel.numberOfLines = 3;
    _noDataLabel.shadowColor = [UIColor colorWithRed:210.0/255.0
                                               green:210.0/255.0
                                                blue:210.0/255.0 alpha:1.0];
    _noDataLabel.shadowOffset = CGSizeMake(1, 0);
    //[_noDataLabel sizeToFit];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    
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
    
    
    _pullToRefresh = [[PullToRefreshView alloc]
                               initWithScrollView:self.tableView];
    [_pullToRefresh setDelegate:self];
    [self.tableView addSubview:_pullToRefresh];
    
    //flurry log
    NSDictionary *articleParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self.title, @"Nome_Categoria", nil];
    [Utilities logEvent:@"Categoria_turismo_visitata" arguments:articleParams];
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
        cell = [[[NSBundle mainBundle]loadNibNamed:IDIOM_SPECIFIC_STRING(@"AreaTurismoItemCell")
                                              owner:self
                                            options:NULL] objectAtIndex:0];
        UIView *v = [[UIView alloc] init];
        v.opaque = YES;
        v.backgroundColor = [UIColor colorWithRed:194/255.0f green:203/255.0f blue:219/255.0f alpha:1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = v;
        cell.backgroundColor = self.tableView.backgroundColor;
        cell.opaque = YES;
    }
    ((AreaTurismoItemCell *)cell).areaTurismoItem = [(WMTableViewDataSource *)self.tableView.dataSource valueForKey:@"ITEM" atIndexPath:indexPath];
    return cell;
}



#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AreaTurismoItem *item =
        [(WMTableViewDataSource *)self.tableView.dataSource valueForKey:@"ITEM"
                                                            atIndexPath:indexPath];
    DocumentoAreaController *docAreaController = [DocumentoAreaController idiomAllocInit];
    docAreaController.turismoItem = item;
    [self.navigationController pushViewController:docAreaController animated:YES];
    //flurry log
    NSDictionary *articleParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:item.ID], @"ID_Offerta", nil];
    [Utilities logEvent:@"Offerta_turismo_visitata" arguments:articleParams];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(getHeight)]) {
        return [cell getHeight];
    }
    return UITableViewAutomaticDimension;
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
    [_pullToRefresh finishedLoading];
    [self showData];
}


- (void)didReceiveBusinessLogicDataError:(NSString *)error {
    [_pullToRefresh finishedLoading];
    [self stopSpinner];
    [self showErrorView:error];
}



#pragma mark - PullToRefreshDelegate



- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    if(_errorView.showed)
        [self hideErrorView:nil];
    [self fetchData];
}



#pragma mark - ErrorView methods



- (void)stopSpinner{
    [_spinner stopAnimating];
    [_spinner removeFromSuperview];
}


- (void)showErrorView:(NSString*)message {
    CGFloat y = iPhoneIdiom() ? 74.0 : 43.0;
    if(_errorView && _errorView.showed){
        return;
    }

    if (iPadIdiom()) {
        _errorView = [[ErrorView alloc] initWithSize:self.view.frame.size];
    }
    else
        _errorView = [[ErrorView alloc] init];

    _errorView.label.text = message;
    [_errorView.tapRecognizer addTarget:self action:@selector(hideErrorView:)];
    
    CGRect oldFrame = [_errorView frame];
    [_errorView setFrame:CGRectMake(0, y, oldFrame.size.width, 0)];
    
    [self.navigationController.view addSubview:_errorView];
    
    [UIView animateWithDuration:0.5
                     animations:^(void){
                         [_errorView setFrame:CGRectMake(0, y, oldFrame.size.width, oldFrame.size.height)];
                     }
     ];
    _errorView.showed = YES;
}


- (void)hideErrorView:(UITapGestureRecognizer*)gesture {
    CGFloat y = iPhoneIdiom() ? 74.0 : 43.0;
    if(_errorView || _errorView.showed){
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             [_errorView setFrame:CGRectMake(0, y, _errorView.frame.size.width,0)];
                         }
                         completion:^(BOOL finished){
                             //riprovo query quando faccio tap su riprova
                             [self fetchData];
                         }
         ];
        _errorView.showed = NO;
        NSLog(@"%f", self.navigationController.navigationBar.frame.size.height);
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
    [self tableViewReloadDataWrapper];
}



#pragma mark - Private methods



- (void)setupBackgroundView {
    
}


- (void)showData {
    //rimuovo e fermo spinner
    [_spinner removeFromSuperview];
    [_spinner stopAnimating];
    
    [self tableViewReloadDataWrapper];
}


- (void)tableViewReloadDataWrapper {
    if ([self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:0] == 0) {
        [self.tableView.backgroundView addSubview:_noDataLabel];
        _noDataLabel.center = self.view.center;
    }
    else
        [_noDataLabel removeFromSuperview];
    [self.tableView reloadData];
}


    
    
@end
