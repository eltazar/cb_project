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

@interface FormViewController () {
    TextFieldCell *textFieldCell;
}


@end

@implementation FormViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons method


- (void)sendButtonPressed:(id)sender {
    NSLog(@"SEND BUTTON PRESSED");
}


- (void) cancelButtonPressed:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // called when "Next" is pressed
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(TextFieldCell*)[[textField superview]superview]];
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    
    if(nextIndexPath.row < [self.tableView numberOfRowsInSection:0])
        [[((TextFieldCell*)[self.tableView cellForRowAtIndexPath:nextIndexPath]) viewWithTag:1] becomeFirstResponder];
    else [textField resignFirstResponder];
    
    NSLog(@"textFieldShouldReturn row = %d",indexPath.row);
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //NSLog(@"did begin editing, row = %d, super view = %@",indexPath.row, [[textField superview]superview]);
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [_dataModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_dataModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if ([dataKey isEqualToString:@"info"]) {
        // Sezione 1
        cell = [tableView dequeueReusableCellWithIdentifier:@"TextArea"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TextAreaCell" owner:self options:NULL] objectAtIndex:0];
        }
        UITextView *textView = (UITextView*)[cell viewWithTag:1];
        CALayer *imageLayer = textView.layer;
        [imageLayer setCornerRadius:6];
        [imageLayer setBorderWidth:1];
        imageLayer.borderColor = [[UIColor lightGrayColor] CGColor];
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


@end
