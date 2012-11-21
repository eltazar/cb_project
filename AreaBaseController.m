//
//  AreaBaseControllerViewController.m
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaBaseController.h"
#import "AreaDescriptionCell.h"
#import "AreaBase.h"

@interface AreaBaseController () {
    AreaDescriptionCell *_areaDescriptionCell;
    NSMutableDictionary *dataModel;
}

@end

@implementation AreaBaseController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithArea:(AreaBase*)area{
   
    self = [super init];
  
    if(self){
        self.area = area;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _areaDescriptionCell = [[[NSBundle mainBundle] loadNibNamed:@"AreaDescriptionCell"
                                                          owner:nil
                                                        options:nil] objectAtIndex:0];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    dataModel = [self.area getDataModel];
    self.title = [self.area titolo];
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
    //NSLog(@"NUMERO SEZIONI = %d",[[dataModel objectForKey:@"sections"] count]);
    return [[dataModel objectForKey:@"sections"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"NUMERO RIGHE = %d, sezione  = %d",[[[dataModel objectForKey:@"data"] objectAtIndex:section] count], section);
    // Return the number of rows in the section.
    return [[[dataModel objectForKey:@"data"] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell;
    NSString *cellIdentifier;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return _areaDescriptionCell;
    }
    
    else {
        
        NSArray *arrayData = [dataModel objectForKey:@"data"];
        NSArray *data = [arrayData objectAtIndex:indexPath.section];
                
        cellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            NSLog(@"Attanziò: sto creando una cella normale");
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = [data objectAtIndex:indexPath.row];
                //TODO aggiungere icona telefono e mail
                break;
            case 1:
                //prendo l'array di dati per la sezione 1
                //prendo l'iesimo dizionario
                //ottengo l'array di kiavi, che in questo caso x ogni dizionario è 1 sola, e scelgo la prima chiave = titolo del pdf
                cell.textLabel.text = [[[data objectAtIndex:indexPath.row] allKeys] objectAtIndex:0];
                //TODO: aggiungere immagine PDF più  
                break;
            case 2:
                cell.textLabel.text = [data objectAtIndex:indexPath.row];
                break;
            default:
                break;
        }
        
        
    }
    
    return cell;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSLog(@"SEZIONE = %@",[[dataModel objectForKey:@"sections"] objectAtIndex:section]);
    return [[dataModel objectForKey:@"sections"] objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        AreaDescriptionCell *cell = (AreaDescriptionCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell getHeight];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
