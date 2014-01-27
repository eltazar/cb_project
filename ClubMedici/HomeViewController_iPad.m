//
//  HomeViewController_iPad.m
//  ClubMedici
//
//  Created by mario greco on 19/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController_iPad.h"

@interface HomeViewController_iPad ()
{
    IBOutlet UIView *titleView;
}
@end

@implementation HomeViewController_iPad

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



# pragma mark - iOS 5 specific



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        //nslog(@"PORTRAIT");
    }
    else{
        //nslog(@"LANDSCAPE");

    }
}



#pragma mark - UISplitViewControllerDelegate



- (void)splitViewController:(UISplitViewController*)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem*)barButtonItem
       forPopoverController:(UIPopoverController*)pc {
    [barButtonItem setTitle:@"Menu"];
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
   // [self setPopoverController:pc];
}


- (void)splitViewController:(UISplitViewController*)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [[self navigationItem] setLeftBarButtonItem:nil];
    //[self setPopoverController:nil];
}


- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}



#pragma mark - WMHTTPAccessDelegate



- (void)didReceiveJSON:(NSArray *)jsonArray {
    //NSLog(@"JSON = %@",jsonArray);
    [super didReceiveJSON:jsonArray];
    
    NSString *htmlPage =
        @"                                                      \
        <html>                                                  \
            <head>                                              \
                <meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0;\">                               \
                <style type=\"text/css\">%@</style>             \
            </head>                                             \
            <body>                                              \
                <h3>%@</h3>                                     \
                <img src=\"%@\" class=\"floatLeft\">            \
                %@                                              \
            </body>                                             \
        </html>";
    
    
    NSString *style =
        @"                                                  \
        img.floatLeft {                                     \
            height: 150px;                                  \
            width:  150px;                                  \
            float:  left;                                   \
            margin: 0 15px 10px 0;                          \
        }                                                   \
                                                            \
        body {                                              \
            font-family: helvetica;                         \
            background-color: #f3f4f5;                      \
        }                                                   \
                                                            \
        body, p {                                           \
            margin:      15px;                              \
            font-size:   18px;                              \
            color:       #464646;                           \
            text-shadow: #fff 0px 1px 0px;                  \
            text-align:  justify;                           \
        }                                                   \
                                                            \
        h1, h2, h3, h4, h5, h6 {                            \
            margin: 0;                                      \
            margin-bottom: 40px;                            \
            font-family: helvetica;                         \
            font-size: 130%;                                \
            color: #0D4383;                                 \
            text-shadow:    rgba(0,0,0,0.5) -0.5px 0,       \
                            rgba(0,0,0,0.3) 0 -0.5px,       \
                            rgba(255,255,255,0.5) 0.5px,    \
                            rgba(0,0,0,0.3) -0.5px -0.5px;  \
        }";
    
    //font-size: 16px;text-align: justify;color: #272727;text-shadow: 1px 4px 6px #f6faff, 0 0 0 #000, 1px 4px 6px #f6faff;}";//
    NSString *img = [NSString stringWithFormat:@"%@%@",
                     URL_NEWS_IMG,
                     [[jsonArray objectAtIndex:0] objectForKey:@"foto"]];
    htmlPage = [NSString stringWithFormat:htmlPage,style,
                [[jsonArray objectAtIndex:0]objectForKey:@"titolo"],
                img,
                [[jsonArray objectAtIndex:0]objectForKey:@"testo"]];
    [webView loadHTMLString:htmlPage baseURL:[NSURL URLWithString:BASE_URL]];
}


- (void)didReceiveError:(NSError *)error {
    [super didReceiveError:error];
}



#pragma mark - ErrorView methods



- (void)showErrorView:(NSString*)message {
    if(errorView == nil || !errorView.showed){
        errorView = [[ErrorView alloc] initWithSize:self.view.frame.size];
        [super showErrorView:message];
    }
}



#pragma mark - SharingProvider informal protocol



-(void)showShareActionSheet:(UIActionSheet *)actionSheet sender:(UIBarButtonItem *)sender {
    
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

-(void)dismissShareActionSheet:(UIActionSheet *)actionSheet sender:(UIBarButtonItem *)sender {
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
