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
    IBOutlet UIView *newsView;
    IBOutlet UIWebView *newsWebView;
    IBOutlet UILabel *newsTitle;
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
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];
    
    newsView.backgroundColor = [UIColor colorWithRed:207/255.0f green:216/255.0f blue:226/255.0f alpha:1];
    titleView.layer.borderColor = [UIColor colorWithRed:78/255.0f green:111/255.0f blue:147/255.0f alpha:0.8].CGColor;
    titleView.layer.masksToBounds = NO;
    titleView.layer.shadowOffset = CGSizeMake(-1, 1);
    titleView.layer.shadowRadius = 5;
    titleView.layer.shadowOpacity = 0.6;
    newsWebView.scrollView.scrollEnabled = TRUE;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - iOS 5 specific

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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

-(void)didReceiveJSON:(NSArray *)jsonArray{
    NSLog(@"JSON = %@",jsonArray);
    newsTitle.text = [NSString stringWithFormat:@"News: %@",[[jsonArray objectAtIndex:0]objectForKey:@"titolo"]];
    
    NSString *htmlPage = @"<html><head><style type=\"text/css\">%@</style></head>    <body>%@</body></html>";
    NSString *style = @"body {text-align:left;font-family:helvetica;}body,p {margin-top:20px;margin-left:45px;font-size: 13px;color: #212121;text-shadow: #fff 0px 1px 0px;}";//font-size: 16px;text-align: justify;color: #272727;text-shadow: 1px 4px 6px #f6faff, 0 0 0 #000, 1px 4px 6px #f6faff;}";//
    htmlPage = [NSString stringWithFormat:htmlPage,style,[[jsonArray objectAtIndex:0]objectForKey:@"testo"]];
    [newsWebView loadHTMLString:htmlPage baseURL:nil];
}

-(void)showErrorView:(NSString*)message{
    
    if(errorView == nil || !errorView.showed){
        errorView = [[ErrorView alloc] initWithSize:self.view.frame.size];
        [super showErrorView:message];
    }
}

@end
