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
    webView.scrollView.contentInset =  UIEdgeInsetsMake(40.0,0.0,0.0,0.0);
    titleLabel.frame = CGRectMake(15, -30, 300,40);
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    titleLabel.numberOfLines = 1;
    titleLabel.minimumFontSize = 12;
    titleLabel.adjustsFontSizeToFitWidth = YES;
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

#pragma mark - WMHttpAccessDelegate

-(void)didReceiveJSON:(NSArray *)jsonArray{
    NSLog(@"json = %@",jsonArray);
    [super didReceiveJSON:jsonArray];
    
    NSString *htmlPage = @"<html><head><style type=\"text/css\">%@</style></head>    <body><img src=\"%@\" class=\"floatLeft\"> %@</body></html>";
    NSString *style = @"img {padding:1px;border:1px solid #000000;background-color:#f6faff;}img.floatLeft{height:100px;width:100px;float: left;margin: 5px;}body {font-family:helvetica;background-color: #f6faff;}body,p{margin:15px;font-size: 16px;color: #212121;text-shadow: #fff 0px 1px 0px;}";//font-size: 16px;text-align: justify;color: #272727;text-shadow: 1px 4px 6px #f6faff, 0 0 0 #000, 1px 4px 6px #f6faff;}";//
    NSString *img = [NSString stringWithFormat:@"%@%@",URL_NEWS_IMG,[[jsonArray objectAtIndex:0] objectForKey:@"foto"]];
    htmlPage = [NSString stringWithFormat:htmlPage,style,img,[[jsonArray objectAtIndex:0]objectForKey:@"testo"]];
    [webView loadHTMLString:htmlPage baseURL:[NSURL URLWithString:BASE_URL]];
}

-(void)didReceiveError:(NSError *)error{
    [super didReceiveError:error];
}

#pragma mark - ErrorView methods

-(void)showErrorView:(NSString*)message{
    
    if(errorView == nil || !errorView.showed){
        errorView = [[ErrorView alloc] init];
        [super showErrorView:message];
    }
}

@end
