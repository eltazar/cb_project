//
//  RichiestaIscrizioneController.m
//  ClubMedici
//
//  Created by mario greco on 23/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "RichiestaIscrizioneController.h"
#import "WMTableViewDataSource.h"
#import "MBProgressHUD.h"
#import "ActionSheetPicker.h"
#import "AbstractActionSheetPicker.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]
#define replaceSpace( object ) [object stringByReplacingOccurrencesOfString:@" " withString:@""]

#define ISCRIZIONE_MAIL @"iscrizioni@clubmedici.it"
#define PICKER_TAG 100

@interface RichiestaIscrizioneController (){
    NSString *name;
    NSString *surname;
    NSString *bornDate;
    NSString *city;
    NSString *email;
    NSString *phone;
}
@end

@implementation RichiestaIscrizioneController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataModel = [[WMTableViewDataSource alloc] initWithPList:@"RichiestaIscrizione"];    }
    return self;
}

- (id)init {
    self = [super initWithNibName:@"FormViewController" bundle:nil];
    if(self){
        _dataModel = [[WMTableViewDataSource alloc] initWithPList:@"RichiestaIscrizione"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.title = @"Diventa socio";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if([textField.placeholder isEqualToString:@"Data di nascita"]){
        [self selectADate:textField];
        return NO;
    }
    else return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if ([dataKey isEqualToString:@"name"]){
        name = textField.text;
    }
    else if ([dataKey isEqualToString:@"surname"]){
        surname = textField.text;
    }
    else if ([dataKey isEqualToString:@"email"]){
        email = textField.text;
    }
    else if ([dataKey isEqualToString:@"phone"]){
        phone = textField.text;
    }
//    else  if ([dataKey isEqualToString:@"data"]){
//        bornDate = textField.text;
//    }
    else if ([dataKey isEqualToString:@"place"]){
        city = textField.text;
    }
}

-(BOOL)validateFields{
    
    //nslog(@"DATA = %@", bornDate);
    NSString *reason = @"";
    BOOL isValid = TRUE;
    //NSLog(@"telefono = %@",replaceSpace(phone));
    if([allTrim(name) length] == 0|| [allTrim(surname) length] == 0 ||
       [allTrim(phone) length] == 0 || [allTrim(email) length] == 0 || [allTrim(city) length] == 0
       || [allTrim(bornDate) length] == 0){
        //nslog(@"mostra avviso completa tutti i campi");
        reason = @"Per favore compila \n tutti i campi richiesti";
        isValid = FALSE;
    
    }
    else{
        if([allTrim(name) length] < 3) {
            reason = @"Per favore inserisci un nome valido";
            isValid = FALSE;
        }
        if([allTrim(surname) length] < 2) {
            reason = @"Per favore inserisci un cognome valido";
            isValid = FALSE;
        }
        if([allTrim(city) length] <= 2) {
            reason = @"Per favore inserisci una città valida";
            isValid = FALSE;
        }
        if (![Utilities isNumeric:replaceSpace(phone)] || [allTrim(phone) length] <= 7) {
            //NSLog(@"mostra avviso telefono errato");
            reason = @"Per favore inserisci un numero di telefono valido";
            isValid = FALSE;
        }
        if(![Utilities checkEmail:email]){
            //NSLog(@"mostra avviso email errato");
            reason = @"Per favore inserisci un indirizzo e-mail valido";
            isValid = FALSE;
        }
    }
    
    if(!isValid){
       // //nslog(@"mostra alert");
        
        UIAlertView *alertView = [[UIAlertView alloc]init];
        alertView.title = reason;
        [alertView setCancelButtonIndex:0];
        [alertView setCancelButtonIndex:[alertView addButtonWithTitle:@"OK"]];
        [alertView show];
    }
    
    return  isValid;
}

-(NSString*)createHtmlBody{
    
    NSString *body = [NSString stringWithFormat:@"Richiesta informazioni <br><br><b>Nome</b>: %@ <br><b>Cognome</b> : %@ <br> <b>Cellulare</b>: %@ <br><b>E-mail</b>: %@ <br><b>Data di nascita</b>: %@ <br><b>Luogo di nascita</b: %@>",name,surname,phone,email,bornDate,city];
    return body;
}

-(void)sendRequest{
    [super sendRequest];
    //nslog(@"BODY = %@",[self createHtmlBody]);
    [PDHTTPAccess sendEmail:[self createHtmlBody] object:@"Richiesta iscrizione" address:ISCRIZIONE_MAIL delegate:self];
    [Utilities logEvent:@"Richiesta_iscrizione_inviata" arguments:nil];
    
}

#pragma mark - Action Methods

- (void)selectADate:(UIControl *)sender {
    
    [self.view endEditing:YES];
    NSDate *selectedDate = [NSDate date];
    AbstractActionSheetPicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Data di nascita" datePickerMode:UIDatePickerModeDate selectedDate:selectedDate target:self action:@selector(dateWasSelected:element:) origin:sender];
    actionSheetPicker.hideCancel = YES;
    [actionSheetPicker showActionSheetPicker];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d-MM-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:selectedDate];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    UITextField *textFieldDate = (UITextField*)[selectedCell viewWithTag:1];
    //nslog(@"textfield = %@",textFieldDate);
    textFieldDate.text = dateString;
    bornDate = dateString;
}
@end
