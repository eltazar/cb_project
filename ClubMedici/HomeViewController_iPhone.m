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
    //NSLog(@"json = %@",jsonArray);
    [super didReceiveJSON:jsonArray];
    
    NSString *htmlPage =
        @"<html>                                        \
            <head>                                      \
                <style type=\"text/css\">%@</style>     \
            </head>                                     \
            <body> <h3>%@</h3><br>                         \
                <img src=\"%@\" class=\"floatLeft\">    \
                %@                                      \
            </body>                                     \
        </html>";
    NSString *style =
        @"img {                             \
            padding:1px;                    \
            border:1px solid #000000;       \
            background-color:#f6faff;       \
        }                                   \
        img.floatLeft {                     \
            height:100px;                   \
            width:100px;                    \
            float: left;                    \
            margin: 5px;                    \
        }                                   \
        body {                              \
            font-family:helvetica;          \
            background-color: #f6faff;      \
        }                                   \
        body, p {                           \
            margin:15px;                    \
            font-size: 16px;                \
            color: #212121;                 \
            text-shadow: #fff 0px 1px 0px;  \
        }                                   \
        h1, h2, h3, h4, h5, h6 {            \
            margin: 0;                      \
            font-family: helvetica;         \
            font-size:. 110%;               \
    color: #0D4383;\
    text-shadow: rgba(0,0,0,0.5) -0.5px 0, rgba(0,0,0,0.3) 0 -0.5px, rgba(255,255,255,0.5) 0.5px, rgba(0,0,0,0.3) -0.5px -0.5px;\
        }";
    
    
    //font-size: 16px;text-align: justify;color: #272727;text-shadow: 1px 4px 6px #f6faff, 0 0 0 #000, 1px 4px 6px #f6faff;}";//
    NSString *img = [NSString stringWithFormat:@"%@%@",URL_NEWS_IMG,[[jsonArray objectAtIndex:0] objectForKey:@"foto"]];
    htmlPage = [NSString stringWithFormat:htmlPage,style,[[jsonArray objectAtIndex:0]objectForKey:@"titolo"],img,[[jsonArray objectAtIndex:0]objectForKey:@"testo"]];
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
