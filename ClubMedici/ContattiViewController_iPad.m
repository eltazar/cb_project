//
//  ContattiViewController_iPad.m
//  ClubMedici
//
//  Created by mario greco on 03/02/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "ContattiViewController_iPad.h"
#import <QuartzCore/QuartzCore.h>
#import "CreditsViewController.h"


@interface ContattiViewController_iPad ()
{
    //IBOutlet UIView *shadow;
    NSString *phone;
    UIPopoverController *creditsPopover;
    UIBarButtonItem *modalButton;
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

- (void)viewDidLoad{
    
    _dataModel = [[WMTableViewDataSource alloc] initWithPList:@"Contatti_ipad"];
     
    UIImageView *shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.size.height, 1536, 5)];
    shadow.image = [UIImage imageNamed:@"ipadShadow"];
    [self.view addSubview:shadow];
        
    companyDescriptionCellCollapsedHeight = 90;
    
    [super viewDidLoad];
    
    NSArray *sedi = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Sedi" ofType:@"plist"]];
    
    for(NSDictionary *o in sedi){
        CLLocationCoordinate2D c = CLLocationCoordinate2DMake([[o objectForKey:@"LAT"] floatValue],[[o objectForKey:@"LONG"]floatValue]);
        Sede *s = [[Sede alloc] initWithCoordinate:c];
        [o objectForKey:@"LAT"];
        s.name = [o objectForKey:@"NAME"];
        s.city = [o objectForKey:@"CITY"];
        s.address = [o objectForKey:@"ADDRESS"];
        [sediPin addObject:s];
    }
    
	modalButton = self.navigationItem.rightBarButtonItem;
    
    CreditsViewController *c = [[CreditsViewController alloc] initWithNibName:@"CreditsViewController" bundle:nil];
    c.tableView.frame = CGRectMake(0, 0, 300, 180);
    creditsPopover = [[UIPopoverController alloc] initWithContentViewController:c];
    creditsPopover.popoverContentSize = c.view.frame.size;
}

-(void)credits:(id)sender{
    //popover.delegate = self;
    
    if ([creditsPopover isPopoverVisible]) {
        [creditsPopover dismissPopoverAnimated:YES];
    }
    else{
        [creditsPopover presentPopoverFromBarButtonItem:modalButton
                               permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [mapView addAnnotations:sediPin];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(((Sede*)[sediPin objectAtIndex:0]).coordinate, 700000, 700000);
    [mapView setRegion:viewRegion];
    [mapView selectAnnotation:[sediPin objectAtIndex:0] animated:YES];
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if([dataKey isEqualToString:@"phone"]){
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, 0.0f,1024, 1.5f);
        bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
        //linea separatrice alta 1px, posizionata alla base inferiore della cella
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
        line.opaque = YES;
        line.tag = 999;
        line.layer.borderColor = [UIColor colorWithRed:214/255.0f green:226/255.0f blue:241/255.0f alpha:1].CGColor;
        line.layer.borderWidth = 1.0;
        //applico bordo inferiore
        [line.layer addSublayer:bottomBorder];
        //applico linea alla cella
        [cell.contentView addSubview:line];        
    }
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];

    if([dataKey isEqualToString:@"phone"])
        [self copyAction:indexPath];
    else [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

//decommentare se vogliamo che il popup COPIA compari tenendo premuta la cella
/*
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
        //nslog(@"Copio in clipboard");
        NSString *text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
        NSString *copyString = [[NSString alloc] initWithFormat:@"%@",text];
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:copyString];
    }
}
*/

-(void)copyAction:(NSIndexPath*)indexPath{
    [self becomeFirstResponder];
    
    /*get the view from the UIBarButtonItem*/
    //UIView *buttonView=[[event.allTouches anyObject] view];
    //CGRect buttonFrame= [self.callButton convertRect:self.callButton.frame toView:footerView];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    phone = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];

    UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"Copia" action:@selector(menuItemClicked:)];
    
    NSAssert([self becomeFirstResponder], @"Sorry, UIMenuController will not work with %@ since it cannot become first responder", self);
    [menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
    [menuController setTargetRect:cell.frame inView:cell.superview];
    [menuController setMenuVisible:YES animated:YES];
    
}

- (void) menuItemClicked:(id) sender {
    // called when Item clicked in menu
    [[UIPasteboard generalPasteboard] setString:phone];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}
- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(menuItemClicked:) /*selector == @selector(copy:)*/){//*<--enable that if you want the copy item */) {
        return YES;
    }
    return NO;
}
- (BOOL) canBecomeFirstResponder {
    return YES;
}



@end
