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

//    self.mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.tableView.frame.size.height);
//    self.mapView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
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

#pragma mark - TableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    if([dataKey isEqualToString:@"phone"])
        return YES;
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{        
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)){
        NSLog(@"Copio in clipboard");
        NSString *text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
        NSString *copyString = [[NSString alloc] initWithFormat:@"%@",text];
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:copyString];
    }
}


@end
