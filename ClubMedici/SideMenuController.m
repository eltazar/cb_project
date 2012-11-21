//
//  SideMenu.m
//  ClubMedici
//
//  Created by mario greco on 18/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "SideMenuController.h"

@interface SideMenuController()

@end

@implementation SideMenuController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //TODO: da sistemare la sua posizione nella navBar
    self.title = @"ClubMedici";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //creo le sezioni
    NSMutableArray *secFinArea = [[NSMutableArray alloc] init];
    NSMutableArray *secAssicArea = [[NSMutableArray alloc] init];
    NSMutableArray *secTravelArea = [[NSMutableArray alloc] init];
    
    
    [secFinArea insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"AreaFinanziaria",              @"DataKey",
                         @"Area finanziaria",  @"label",
                         @"",                  @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         nil] atIndex: 0];
    
    [secFinArea insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"AreaCureMediche",             @"DataKey",
                         @"Cure mediche rateali",      @"label",
                         @"",         @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         nil] atIndex: 1];
    
    [secFinArea insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"AreaLeasing",            @"DataKey",
                         @"Leasing e noleggio",       @"label",
                         @"",         @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         nil]  atIndex: 2];
    
    [secAssicArea insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"AreaAssicurativa",             @"DataKey",
                         @"Area assicurativa",   @"label",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         nil] atIndex: 0];
    [secTravelArea insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                @"AreaViaggi",             @"DataKey",
                                @"Viaggi e turismo",   @"label",
                                @"",                 @"img",
                                [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                                nil] atIndex: 0];
    
    
    self.sectionData = [[NSArray alloc] initWithObjects:secFinArea, secAssicArea,secTravelArea, nil];
    self.sectionDescription = [[NSArray alloc] initWithObjects:@"Area finanziaria",@"Area assicurativa",@"Area viaggi e turismo",nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sectionDescription.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sectionData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sec = [self.sectionData objectAtIndex:indexPath.section];
    NSDictionary *rowDesc = [sec objectAtIndex:indexPath.row];
    //NSString *dataKey = [rowDesc objectForKey:@"DataKey"];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [rowDesc objectForKey:@"label"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionDescription objectAtIndex:section];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
