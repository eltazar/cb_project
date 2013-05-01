//
//  ContattiViewController_iPad.m
//  ClubMedici
//
//  Created by mario greco on 03/02/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "ContattiViewController_iPad.h"
#import <QuartzCore/QuartzCore.h>

@interface ContattiViewController_iPad ()
{
    //IBOutlet UIView *shadow;
}
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
    UIImageView *shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.size.height, 1536, 5)];
    shadow.image = [UIImage imageNamed:@"ipadShadow"];
    [self.view addSubview:shadow];
    
    [self.view addSubview:mapView];
    self.tableView.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
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
