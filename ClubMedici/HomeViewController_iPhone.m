//
//  HomeViewController_iPhone.m
//  ClubMedici
//
//  Created by mario greco on 19/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "HomeViewController_iPhone.h"


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface HomeViewController_iPhone ()
{
    NewsPullableView *newsView;
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
    
    newsView.animationDuration = 0.15f;
    newsView.openedCenter = CGPointMake(160 + 0,self.view.center.y+25);
    newsView.closedCenter = CGPointMake(160 + 0, self.view.frame.size.height+closedCenterOffset);
    newsView.center = newsView.closedCenter;
    newsView.handleView.frame = CGRectMake(0, 0, 320, 40);
    newsView.delegate = self;
    [newsView setUserInteractionEnabled:NO];
    
    
    descriptionLabel.textColor     = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    descriptionLabel.shadowColor   = [UIColor darkGrayColor];
    descriptionLabel.shadowOffset  = CGSizeMake(-1.0,-1.0);
    
    //setto bottone per condivisione facebook, twitter, email
    SharingPanelView *sharingView = newsView.sharingView;
    NSLog(@"SHARING VIEW = %@",sharingView);
    [sharingView.fbButton addTarget:self action:@selector(postToFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [sharingView.twButton addTarget:self action:@selector(postToTwitter:) forControlEvents:UIControlEventTouchUpInside];
    [sharingView.mailButton addTarget:self action:@selector(postToMail:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:newsView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self fetchData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened {
    if (opened) {
        //NSLog(@"Now I'm open!");
       [newsView rotateArrow:YES];
    } else {
        //NSLog( @"Now I'm closed, pull me up again!");
        [newsView rotateArrow:NO];
    }
}

#pragma mark - WMHttpAccessDelegate

-(void)didReceiveJSON:(NSArray *)jsonArray{
    
    [super didReceiveJSON:jsonArray];
    [newsView setUserInteractionEnabled:YES];
    
    newsView.descrizioneBreve.text = [NSString stringWithFormat:@"News: %@",[[jsonArray objectAtIndex:0]objectForKey:@"titolo"]];
    NSString *htmlPage = @"<html><head><style type=\"text/css\">%@</style></head>    <body>%@</body></html>";
    NSString *style = @"body {font-family:helvetica;background-color: #cfd8e2;}body,p {margin:15px;font-size: 13px;color: #212121;text-shadow: #fff 0px 1px 0px;}";//font-size: 16px;text-align: justify;color: #272727;text-shadow: 1px 4px 6px #f6faff, 0 0 0 #000, 1px 4px 6px #f6faff;}";//
    htmlPage = [NSString stringWithFormat:htmlPage,style,[[jsonArray objectAtIndex:0]objectForKey:@"testo"]];
    [newsView.descrizioneEstesa loadHTMLString:htmlPage baseURL:nil];
}

-(void)didReceiveError:(NSError *)error{
    [newsView setUserInteractionEnabled:NO];
    newsView.descrizioneBreve.text = @"Impossibile caricare le news, riprovare";
    [super didReceiveError:error];
}

#pragma mark - ErrorView methods

-(void)showErrorView:(NSString*)message{
    
    if(errorView == nil || !errorView.showed){
        errorView = [[ErrorView alloc] init];
        [super showErrorView:message];
    }
}

#pragma mark - UI Buttons
-(void)postToFacebook:(id)sender{
    [super postToFacebook:sender];
}

@end
