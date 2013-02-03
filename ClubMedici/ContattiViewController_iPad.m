//
//  ContattiViewController_iPad.m
//  ClubMedici
//
//  Created by mario greco on 03/02/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "ContattiViewController_iPad.h"

@interface ContattiViewController_iPad ()

@end

@implementation ContattiViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.tableView.frame.size.height);
    self.mapView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if([dataKey isEqualToString:@"company"]){
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"WebViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"WebViewCell" owner:self options:NULL] objectAtIndex:0];
        }
        UIWebView *webView =(UIWebView*) [cell viewWithTag:3];
        [webView loadHTMLString:[_dataModel valueForKey:@"LABEL" atIndexPath:indexPath] baseURL:nil];
        UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        bgview.opaque = YES;
        bgview.backgroundColor = [UIColor whiteColor];
        [cell setBackgroundView:bgview];
    }
    else{
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

@end
