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

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]
#define replaceSpace( object ) [object stringByReplacingOccurrencesOfString:@" " withString:@""]

#define ISCRIZIONE_MAIL @"iscrizioni@clubmedici.it"

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
    //self.title = @"Richiesta iscrizione";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        customTitle.text = @"Richiedi \n iscrizione";
        self.navigationItem.titleView = customTitle;
    }
    else{
        self.title = @"Richiedi iscrizione";
    }    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

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
    else  if ([dataKey isEqualToString:@"data"]){
        bornDate = textField.text;
    }
    else if ([dataKey isEqualToString:@"place"]){
        city = textField.text;
    }
}

-(BOOL)validateFields{
    
    NSString *reason = @"";
    BOOL isValid = TRUE;
    NSLog(@"telefono = %@",replaceSpace(phone));
    if([allTrim(name) length] == 0|| [allTrim(surname) length] == 0 ||
       [allTrim(phone) length] == 0 || [allTrim(email) length] == 0 || [allTrim(city) length] == 0 || [allTrim(bornDate) length] == 0){
        //NSLog(@"mostra avviso completa tutti i campi");
        reason = @"Per favore compila \n tutti i campi richiesti";
        isValid = FALSE;
        
    }
    else if (![Utilities isNumeric:replaceSpace(phone)]) {
        //NSLog(@"mostra avviso telefono errato");
        reason = @"Per favore inserisci un numero di telefono valido";
        isValid = FALSE;
    }
    else if(![Utilities checkEmail:email]){
        //NSLog(@"mostra avviso email errato");
        reason = @"Per favore inserisci un indirizzo e-mail valido";
        isValid = FALSE;
    }
    
    if(!isValid){
       // NSLog(@"mostra alert");
        
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
    NSLog(@"BODY = %@",[self createHtmlBody]);
    [PDHTTPAccess sendEmail:[self createHtmlBody] object:@"Richiesta iscrizione" address:ISCRIZIONE_MAIL delegate:self];
}

@end
