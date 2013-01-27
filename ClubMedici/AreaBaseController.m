//
//  AreaBaseControllerViewController.m
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>

#import "AreaBaseController.h"
#import "AreaDescriptionCell.h"
#import "AreaBase.h"
#import "PDFviewerController.h"
#import "RichiestaNoleggioController.h"
#import "WMTableViewDataSource.h"
#import "CachedAsyncImageView.h"

@interface AreaBaseController () {
}
@end

@implementation AreaBaseController
@synthesize area;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = [self.area titolo];

    NSLog(@"ViewDidLoad: AreaBaseController");

    
    //ottengo il dataModel per l'oggeto area
    _dataModel = [self.area getDataModel];
    
    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.dataSource = _dataModel;
    _dataModel.cellFactory = self;
    
    NSURL *imageURL = [NSURL URLWithString:@"http://www.nightheaven.org/wp-content/gallery/boku_wa_tomodachi_ga_sukunai-wallpaper-01/boku_wa_tomodachi_ga_sukunai-wallpaper-06-2048_1536.jpg"];
    imageView = [[CachedAsyncImageView alloc] init];
    imageView.delegate = self;
    [imageView loadImageFromURL:imageURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - iOS 5 specific

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActionCell" owner:self options:NULL] objectAtIndex:0];
    }
    UILabel *label   = (UILabel *)    [cell viewWithTag:1];
    UIImageView *img = (UIImageView *)[cell viewWithTag:2];
    
    label.text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
    
    if([dataKey isEqualToString:@"pdf"]){
        [img setImage:[UIImage imageNamed:@"pdfImage"]];  
    }
    else if([dataKey isEqualToString:@"phone"]){
        [img setImage:[UIImage imageNamed:@"phone"]];
    }
    else if([dataKey isEqualToString:@"email"]){
        [img setImage:[UIImage imageNamed:@"mail"]];
    }
    
    UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    bgview.opaque = YES;
    bgview.backgroundColor = [UIColor whiteColor];
    [cell setBackgroundView:bgview];
    // At end of function, right before return cell:
    //cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - Table view delegate

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_dataModel tableView:tableView titleForHeaderInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if(indexPath.section == 2){
        
        if([dataKey isEqualToString:@"cure"]){
            //FormViewController *formController = [[FormViewController alloc] initWithNibName:@"FormViewController" bundle:nil];
            //[self.navigationController pushViewController:formController animated:YES];
            NSLog(@"CELLA CURE MEDICHE ---> devo lanciare calcolatore php");
            
        }
        else {
            
            NSLog(@" CELLA NOLEGGIO = %@", dataKey);
            RichiestaNoleggioController *formController = [[RichiestaNoleggioController alloc] init:dataKey];
            [self.navigationController presentModalViewController:[[UINavigationController alloc] initWithRootViewController:formController]  animated:YES];
        }
    }
    
    else {
        if ([dataKey isEqualToString:@"phone"]) {
            NSLog(@"numero di telefono = %@",
                  [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath]);
            [self callNumber: [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath]];
        }
        else if ([dataKey isEqualToString:@"pdf"]) {
            NSString *title = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
            PDFviewerController *pdfViewer = [[PDFviewerController alloc]initWithTitle:title                                                                      url:nil];
            [self.navigationController presentViewController:pdfViewer animated:YES completion:nil];
        }
        else if ([dataKey isEqualToString:@"email"]) {
            [self sendEmail:[_dataModel valueForKey:@"LABEL" atIndexPath:indexPath]];
        }
            
    }
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    CustomHeader *header = [[CustomHeader alloc] init] ;
//    header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
//    return header;
//}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}


#pragma mark - Private methods


- (void)callNumber:(NSString*)number {
    //fa partire una chiamata
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
            NSString *phoneNumber = [NSString stringWithFormat:@"%@%@", @"tel://", number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber
                                                        ]];
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Spiacenti" message:@"Questa funzione non è disponibile su questo dispositivo" delegate:nil cancelButtonTitle:@"Chiudi" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)sendEmail:(NSString*)address {
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


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
        
    [self dismissModalViewControllerAnimated:YES];
    
	if (result == MFMailComposeResultFailed){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messaggio non inviato!" message:@"Non è stato possibile inviare la tua e-mail" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil];
		[alert show];
	}
    else if (result == MFMailComposeResultCancelled){
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

#pragma mark - Private methods

- (void)setupBackgroundView {
    
    NSLog(@"AREA BASE CONTROLLER: setup background view");
    
    CGFloat tableViewWidth = self.tableView.frame.size.width;
    UIView *backgroundView = [[UIView alloc]init];
    imageView.frame = CGRectMake(0, 0,
                                 tableViewWidth,
                  
                                 
                                 
                                 
                                 
                                 
                                 tableViewWidth * (imageView.image.size.height / imageView.image.size.width)
                                 );
    [backgroundView addSubview:imageView];
    self.tableView.backgroundView = backgroundView;
    
    //per fare in modo che l'immagine nell'header diventi trasparente gradualmente verso la fine dell'immagine stessaUIView *backgroundView = [[UIView alloc] init];
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = imageView.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    l.startPoint = CGPointMake(1.0f, .6f);
    l.endPoint = CGPointMake(1.0f, 1.0f);
    imageView.layer.mask = l;
    
    
    //per far iniziare la tableView con un offset
    [UIView animateWithDuration:.5
                     animations:^(void) {
                         self.tableView.tableHeaderView =
                         [[UIView alloc] initWithFrame:
                          CGRectMake(0, 0,
                                     tableViewWidth,
                                     0.6 * imageView.frame.size.height
                                     )
                          ];
                     }
     ];
     NSLog(@"frame.width = %f, height = %f", tableViewWidth,backgroundView.frame.size.height);
    
}


#pragma mark - CachedAsyncImageDelegate
-(void)didFinishLoadingImage:(id)sender{
    
    NSLog(@"SCARICATA IMMAGINE IN AREA CONTROLLER");
    [self setupBackgroundView];
}


@end
