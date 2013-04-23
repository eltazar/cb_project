//
//  FormViewController.m
//  ClubMedici
//
//  Created by mario greco on 22/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "FormViewController.h"
#import "TextFieldCell.h"
#import "WMTableViewDataSource.h"

#define KEYBOARD_ORIGIN_Y self.tableView.frame.size.height - 216.0f

@interface FormViewController () {
    TextFieldCell *textFieldCell;
}

@end

@implementation FormViewController
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //self.title = @"Richiesta preventivo";
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Invia" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonPressed:)];
    self.navigationItem.rightBarButtonItem = button;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //per staccare un po la prima cella dal bordo superiore
    self.tableView.contentInset = UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f);

    self.tableView.dataSource = _dataModel;
    _dataModel.cellFactory = self;
    _dataModel.showSectionHeaders = NO;
    
    customTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    customTitle.backgroundColor = [UIColor clearColor];
    customTitle.numberOfLines = 2;
    customTitle.font = [UIFont boldSystemFontOfSize: 16.0f];
    customTitle.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    customTitle.textAlignment = UITextAlignmentCenter;
    customTitle.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return NO;
    else return YES;
}

#pragma mark - Buttons method


- (void)sendButtonPressed:(id)sender {
    NSLog(@"SEND BUTTON PRESSED");
    
    //fa si che il testo inserito nei texfield sia preso anche se non è stata dismessa la keyboard
    [self.view endEditing:TRUE];
    if([self validateFields]){
        [self sendRequest];
    }
}

-(NSString*)createHtmlBody{
    return nil;
}

-(void)sendRequest{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Invio...";
}

- (void) cancelButtonPressed:(id)sender {
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    if(delegate && [delegate respondsToSelector:@selector(didPressCancelButton:)]){
        [delegate didPressCancelButton:self];
    }
}

-(BOOL)validateFields{
    return FALSE;
}

-(void)showDisclaimer{
    DisclaimerController *disclaimerCntr = [[DisclaimerController alloc] initWithNibName:@"DisclaimerController" bundle:nil];
    [self.navigationController pushViewController:disclaimerCntr animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // called when "Next" is pressed
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(TextFieldCell*)[[textField superview]superview]];
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    
    if(nextIndexPath.row < [self.tableView numberOfRowsInSection:0])
        [[((TextFieldCell*)[self.tableView cellForRowAtIndexPath:nextIndexPath]) viewWithTag:1] becomeFirstResponder];
    else{
        [textField resignFirstResponder];
        //riporta tabella a offset originale
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             self.tableView.contentOffset = CGPointMake(0, -60);
                         }
         ];
    };
    
    NSLog(@"textFieldShouldReturn row = %d",indexPath.row);
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    NSLog(@"y = %f", cell.frame.origin.y);
    
    if(cell.frame.origin.y + textField.frame.size.height >= KEYBOARD_ORIGIN_Y){
        //modifica offset per fare vedere celle nascoste
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y+60);
                         }
         ];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if ([dataKey isEqualToString:@"info"]) {
        // Sezione 1
        cell = [tableView dequeueReusableCellWithIdentifier:@"Disclaimer"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DisclaimerCell" owner:self options:NULL] objectAtIndex:0];
        }
        
        UIButton *disclaimerBtn = (UIButton *)[cell viewWithTag:10];
        [disclaimerBtn addTarget:self action:@selector(showDisclaimer) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        // Sezione 0
        NSLog(@"FormCell %@", indexPath);
        cell = [tableView dequeueReusableCellWithIdentifier:@"FormCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:NULL] objectAtIndex:0];
        }
        
        UITextField *textField = (UITextField*)[cell viewWithTag:1];
        textField.delegate = self;
        textField.placeholder = [_dataModel valueForKey:@"PLACEHOLDER" atIndexPath:indexPath];

    }
    return cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - WMHTPPAccessDelegate 
-(void)didReceiveString:(NSString *)receivedString{
    NSLog(@"Invio mail esito positivo: %@",receivedString);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)didReceiveError:(NSError *)error{
    NSLog(@"Invio mail errore");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
