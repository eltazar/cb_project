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
    NSString *phone;
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
    
    [self.view addSubview:mapView];
    self.tableView.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];
    
    companyDescriptionCellCollapsedHeight = 90;
    
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
        NSLog(@"Copio in clipboard");
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
