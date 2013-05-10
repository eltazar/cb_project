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
    
    webView.scrollView.contentInset =  UIEdgeInsetsMake(80.0,0.0,0.0,0.0);
    titleLabel.frame = CGRectMake(15, -60, 700,60);
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - iOS 5 specific

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation{
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"PORTRAIT");
    }
    else{
        NSLog(@"LANDSCAPE");

    }
}

-(void)shareWithActionSheet:(UIButton*)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Condividi" delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter",@"E-mail", nil];
    actionSheet.delegate = self;
    [actionSheet showFromRect:sender.frame inView:sender.superview animated:YES];
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
    //NSLog(@"JSON = %@",jsonArray);
    [super didReceiveJSON:jsonArray];
    
    NSString *htmlPage = @"<html><head><style type=\"text/css\">%@</style></head>    <body><img src=\"%@\" class=\"floatLeft\"> %@</body></html>";
    NSString *style = @"img {padding:1px;border:1px solid #000000;background-color:#f6faff;}img.floatLeft{height:150px;width:150px;float: left;margin: 5px;}body {font-family:helvetica;background-color: #f6faff;}body,p{margin:15px;font-size: 18px;color: #212121;text-shadow: #fff 0px 1px 0px;}";//font-size: 16px;text-align: justify;color: #272727;text-shadow: 1px 4px 6px #f6faff, 0 0 0 #000, 1px 4px 6px #f6faff;}";//
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
        errorView = [[ErrorView alloc] initWithSize:self.view.frame.size];
        [super showErrorView:message];
    }
}

@end
