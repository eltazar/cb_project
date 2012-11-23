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
#import "PDFviewerController.h"
#import "CustomCellBackground.h"
#import "CustomHeader.h"
#import "RichiestaNoleggioController.h"

@interface AreaBaseController () {
    
    NSMutableDictionary *dataModel;
}

@end

@implementation AreaBaseController
@synthesize area;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithArea:(AreaBase*)a{
   
    self = [super init];
  
    if(self){
        self.area = a;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.title = [self.area titolo];
    
    //ottengo il dataModel per l'oggeto area
    dataModel = [self.area getDataModel];
    
    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//per ios 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
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
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    
        
    NSArray *arrayData = [dataModel objectForKey:@"data"];
    NSArray *data = [arrayData objectAtIndex:indexPath.section];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActionCell" owner:self options:NULL] objectAtIndex:0];
    }
    UILabel *label   = (UILabel *)[cell viewWithTag:1];
    UIImageView *img        = (UIImageView *)[cell viewWithTag:2];
                    
    switch (indexPath.section) {
        case 0:
            label.text = [data objectAtIndex:indexPath.row];
            //TODO aggiungere icona telefono e mail
            [img setImage:[UIImage imageNamed:@"phone"]];
            break;
        case 1:
            //prendo l'array di dati per la sezione 1
            //prendo l'iesimo dizionario
            //ottengo l'array di kiavi, che in questo caso x ogni dizionario è 1 sola, e scelgo la prima chiave = titolo del pdf
            label.text = [[data objectAtIndex:indexPath.row] objectForKey:@"label"];
            //TODO: aggiungere immagine PDF
            [img setImage:[UIImage imageNamed:@"pdf"]];
            break;
        case 2:
            label.text = [[data objectAtIndex:indexPath.row] objectForKey:@"label"];
            
            break;
        default:
            break;
    }
    
    

    
    cell.backgroundView = [[CustomCellBackground alloc] init];
    //cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
    
    // At end of function, right before return cell:
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
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
    NSArray *arrayData = [dataModel objectForKey:@"data"];
    NSArray *data = [arrayData objectAtIndex:indexPath.section];
    NSString *dataKey = nil;;
    
    if([[data objectAtIndex:indexPath.row] respondsToSelector:@selector(objectForKey:)]){
        dataKey = [[data objectAtIndex:indexPath.row] objectForKey:@"DataKey"];
    }
    
    //section 1 sono pdf
    if(indexPath.section == 1){
        

        PDFviewerController *pdfViewer = [[PDFviewerController alloc]initWithTitle:[[data objectAtIndex:indexPath.row] objectForKey:@"label"] url:nil];
        //[self.navigationController pushViewController:pdfViewer animated:YES];
        
        [self.navigationController presentViewController:pdfViewer animated:YES completion:nil];
    }
    else if(indexPath.section == 2){
        
        if([dataKey isEqualToString:@"cure"]){
            //FormViewController *formController = [[FormViewController alloc] initWithNibName:@"FormViewController" bundle:nil];
            //[self.navigationController pushViewController:formController animated:YES];
            NSLog(@"CELLA CURE MEDICHE ---> devo lanciare calcolatore php");
            
        }
        else{
            
            NSLog(@" CELLA NOLEGGIO = %@",dataKey);
            RichiestaNoleggioController *formController = [[RichiestaNoleggioController alloc] init:dataKey];
            
            [self.navigationController presentModalViewController:[[UINavigationController alloc] initWithRootViewController:formController]  animated:YES];
        }
    }
        
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSLog(@"SEZIONE = %@",[[dataModel objectForKey:@"sections"] objectAtIndex:section]);
    return [[dataModel objectForKey:@"sections"] objectAtIndex:section];
}



- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CustomHeader *header = [[CustomHeader alloc] init] ;
    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    return header;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

@end
