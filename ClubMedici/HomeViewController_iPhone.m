//
//  HomeViewController_iPhone.m
//  ClubMedici
//
//  Created by mario greco on 19/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "HomeViewController_iPhone.h"
#import "PDHTTPAccess.h"
#import "ErrorView.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface HomeViewController_iPhone ()
{
    NewsPullableView *newsView;
    ErrorView *errorView;
}
@end

@implementation HomeViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    newsView = [[NewsPullableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 500)];    
    float closedCenterOffset = 0;
    if (IS_IPHONE_5){
        //iphone5
        closedCenterOffset = 250;
        //NSLog(@"iphone 5 ");
    }
    else{
        closedCenterOffset = 165;
        //NSLog(@"iphone 4 ");
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];
    
    newsView.openedCenter = CGPointMake(160 + 0,self.view.center.y+25);
    newsView.closedCenter = CGPointMake(160 + 0, self.view.frame.size.height+closedCenterOffset);
    newsView.center = newsView.closedCenter;
    newsView.handleView.frame = CGRectMake(0, 0, 320, 40);
    newsView.delegate = self;
    
    descriptionLabel.textColor     = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    descriptionLabel.shadowColor   = [UIColor darkGrayColor];
    descriptionLabel.shadowOffset  = CGSizeMake(-1.0,-1.0);
    
    [self.view addSubview:newsView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(errorView && errorView.showed){
        [errorView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    return NO;    //return NO;
}

- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened {
    if (opened) {
        NSLog(@"Now I'm open!");
    } else {
        NSLog( @"Now I'm closed, pull me up again!");
    }
}

-(void)fetchData{
    if([Utilities networkReachable]){
        [PDHTTPAccess getNews:1 delegate:self];
    }
    else{
        [self showErrorView:@"Connessione assente"];
    }
    
}

#pragma mark - WMHttpAccessDelegate

-(void)didReceiveJSON:(NSArray *)jsonArray{
    //NSLog(@"JSON = %@",jsonArray);
   newsView.descrizioneBreve.text = [NSString stringWithFormat:@"News: %@",[[jsonArray objectAtIndex:0]objectForKey:@"titolo"]];
    
    NSString *htmlPage = @"<html><head><style type=\"text/css\">%@</style></head>    <body>%@</body></html>";
    NSString *style = @"body {font-family:helvetica;background-color: #cfd8e2;}body,p,strong {margin:15px;font-size: 13px;color: #212121;text-shadow: #fff 0px 1px 0px;}";//font-size: 16px;text-align: justify;color: #272727;text-shadow: 1px 4px 6px #f6faff, 0 0 0 #000, 1px 4px 6px #f6faff;}";//
    htmlPage = [NSString stringWithFormat:htmlPage,style,[[jsonArray objectAtIndex:0]objectForKey:@"testo"]];
    [newsView.descrizioneEstesa loadHTMLString:htmlPage baseURL:nil];
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"Server error = %@",error.description);
    [self showErrorView:@"Errore server"];
}

-(void)showErrorView:(NSString*)message{
    
    if(errorView == nil || !errorView.showed){
        errorView = [[ErrorView alloc] init];
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
}

-(void)hideErrorView:(UITapGestureRecognizer*)gesture{
    
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



@end
