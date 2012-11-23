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

# pragma mark - iOS 5 specific

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
    NSString *dataKey = [[data objectAtIndex:indexPath.row] objectForKey:@"DataKey"];
    
//    if([[data objectAtIndex:indexPath.row] respondsToSelector:@selector(objectForKey:)]){
//        dataKey = [[data objectAtIndex:indexPath.row] objectForKey:@"DataKey"];
//    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActionCell" owner:self options:NULL] objectAtIndex:0];
    }
    UILabel *label   = (UILabel *)[cell viewWithTag:1];
    UIImageView *img        = (UIImageView *)[cell viewWithTag:2];
    
    label.text = [[data objectAtIndex:indexPath.row] objectForKey:@"label"];
    
    if([dataKey isEqualToString:@"pdf"]){
        [img setImage:[UIImage imageNamed:@"pdfImage"]];  
    }
    else if([dataKey isEqualToString:@"phone"]){
        [img setImage:[UIImage imageNamed:@"phone"]];
    }
    else{
        [img setImage:nil];
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
    NSString *dataKey = [[data objectAtIndex:indexPath.row] objectForKey:@"DataKey"];
    
    
    if(indexPath.section == 2){
        
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
    else{
        
        if([dataKey isEqualToString:@"phone"]){
            NSLog(@"numero di telefono = %@",[[data objectAtIndex:indexPath.row] objectForKey:@"label"]);
            [self callNumber: [[data objectAtIndex:indexPath.row] objectForKey:@"label"]];
        }
        else if([dataKey isEqualToString:@"pdf"]){
            PDFviewerController *pdfViewer = [[PDFviewerController alloc]initWithTitle:[[data objectAtIndex:indexPath.row] objectForKey:@"label"] url:nil];
            //[self.navigationController pushViewController:pdfViewer animated:YES];
            
            [self.navigationController presentViewController:pdfViewer animated:YES completion:nil];
        }
        else if([dataKey isEqualToString:@"email"]){
            [self sendEmail:[[data objectAtIndex:indexPath.row] objectForKey:@"label"]];
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


#pragma mark - Private methods

-(void) callNumber:(NSString*)number{
    
    //fa partire una chiamata
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]){
            NSString *phoneNumber = [NSString stringWithFormat:@"%@%@", @"tel://", number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber
                                                        ]];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Spiacenti" message:@"Questa funzione non è disponibile su questo dispositivo" delegate:nil cancelButtonTitle:@"Chiudi" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) sendEmail:(NSString*)address{
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail]){
        [mail setToRecipients:[NSArray arrayWithObjects:address, nil]];
        [mail setSubject:@"BLABLABLA"];
        [mail setMessageBody:@"" isHTML:NO];
        [self presentModalViewController:mail animated:YES];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
        
    [self dismissModalViewControllerAnimated:YES];
    
	if (result == MFMailComposeResultFailed){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messaggio non inviato!" message:@"Non è stato possibile inviare la tua e-mail" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil];
		[alert show];
	}
    
}


@end
