//
//  RichiestaIscrizioneControllerViewController.m
//  ClubMedici
//
//  Created by mario greco on 23/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "RichiestaNoleggioController.h"
#import "WMTableViewDataSource.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]
#define replaceSpace( object ) [object stringByReplacingOccurrencesOfString:@" " withString:@""]


@interface RichiestaNoleggioController ()
{
    NSString *ragSoc;
    NSString *iva;
    NSString *phone;
    NSString *citta;
    NSString *email;
    NSString *marca;
    NSString *modello;
    NSString *tipo;
    NSString *prezzo;
}
@end

@implementation RichiestaNoleggioController
@synthesize kind;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"FormViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init:(NSString *)kindRequest {
    self = [super initWithNibName:@"FormViewController" bundle:nil];
    if(self){
        self.kind = kindRequest;
    }
    return self;

}

- (void)viewDidLoad {
    if ([self.kind isEqualToString:@"noleggioAuto"]) {
        _dataModel = [[WMTableViewDataSource alloc]
                      initWithPList:@"RichiestaNoleggioAuto"];
    }
    else { // self.kind == noleggioElettro || self.kind == leasingElettro
        _dataModel = [[WMTableViewDataSource alloc]
                      initWithPList:@"RichiestaNoleggioElettromedicale"];
    }
    [super viewDidLoad];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Annula" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = button;
    
    //self.title = @"Richiedi informazioni";

    customTitle.text = @"Richiedi \n informazioni";
    
    self.navigationItem.titleView = customTitle;
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
    
    NSLog(@"2) dataKey %@", dataKey);
    if ([dataKey isEqualToString:@"ragSoc"]){
        ragSoc = textField.text;
    }
    else if ([dataKey isEqualToString:@"cell"]){
        phone = textField.text;
    }
    else if ([dataKey isEqualToString:@"email"]){
        email = textField.text;
    }
    else if ([dataKey isEqualToString:@"citta"]){
        //per auto
        citta = textField.text;
    }
    else if ([dataKey isEqualToString:@"iva"]){
        iva = textField.text;
    }
    else  if ([dataKey isEqualToString:@"marca"]){
        marca = textField.text;
    }
    else if ([dataKey isEqualToString:@"modello"]){
        modello = textField.text;
    }
    else if ([dataKey isEqualToString:@"tipo"]){
        //per elettromedicale
        tipo = textField.text;
    }
    else if ([dataKey isEqualToString:@"prezzo"]){
        prezzo = textField.text;
    }
    
}

-(BOOL)validateFields{
    
    NSString *reason = @"";
    BOOL isValid = TRUE;
    
    if([self.kind isEqualToString:@"noleggioAuto"]){
        if([allTrim(iva) length] == 0|| [allTrim(modello) length] == 0 ||
           [allTrim(marca) length] == 0 ){
           // NSLog(@"mostra avviso completa tutti i campi");
            reason = @"Per favore compila tutti i campi richiesti";
            isValid = FALSE;
            
        }
    }
    else{
        if([allTrim(tipo) length] == 0|| [allTrim(prezzo) length] == 0){
            //NSLog(@"mostra avviso completa tutti i campi");
            reason = @"Per favore compila tutti i campi richiesti";
            isValid = FALSE;
            
        }
    }
    if([allTrim(ragSoc) length] == 0|| [allTrim(phone) length] == 0 ||
       [allTrim(citta) length] == 0){
       // NSLog(@"mostra avviso completa tutti i campi");
        reason = @"Per favore compila tutti i campi richiesti";
        isValid = FALSE;
        
    }
    else if (![Utilities isNumeric:replaceSpace(phone)]) {
       // NSLog(@"mostra avviso telefono errato");
        reason = @"Per favore inserisci un numero di telefono valido";
        isValid = FALSE;
    }
    else if(![Utilities checkEmail:email]){
        //NSLog(@"mostra avviso email errato");
        reason = @"Per favore inserisci un indirizzo e-mail valido";
        isValid = FALSE;
    }
    
    if(!isValid){
        //NSLog(@"mostra alert");
        
        UIAlertView *alertView = [[UIAlertView alloc]init];
        alertView.title = reason;
        [alertView setCancelButtonIndex:0];
        [alertView setCancelButtonIndex:[alertView addButtonWithTitle:@"OK"]];
        [alertView show];
    }
        
    return  isValid;
}


@end
