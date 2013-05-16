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

#define LEASING_MAIL @"leasing@clubmedici.it"
#define NOLEGGIO_MAIL @"noleggio@clubmedici.it"

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
    UILabel *customTitle;
    //UIButton *cancelButton;
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
    
    customTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 480, 44)];
    customTitle.backgroundColor = [UIColor clearColor];
    customTitle.numberOfLines = 2;
    customTitle.font = [UIFont boldSystemFontOfSize: 16.0f];
    customTitle.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    customTitle.textAlignment = UITextAlignmentCenter;
    customTitle.textColor = [UIColor whiteColor];
    //nslog(@"kind = %@",kind);
    if ([self.kind isEqualToString:@"noleggioAuto"]) {
        _dataModel = [[WMTableViewDataSource alloc]
                      initWithPList:@"RichiestaNoleggioAuto"];
         customTitle.font = [UIFont boldSystemFontOfSize: 18.0f];
        customTitle.text = @"Noleggio auto";
    }
    else if([self.kind isEqualToString:@"noleggioElettro"]){
        _dataModel = [[WMTableViewDataSource alloc]
                      initWithPList:@"RichiestaNoleggioElettromedicale"];
        customTitle.text = @"Noleggio elettromedicale";
    }
    else{
        customTitle.text = @"Leasing \n elettromedicale";
        _dataModel = [[WMTableViewDataSource alloc] initWithPList:@"RichiestaNoleggioElettromedicale"];
        
    }
    [super viewDidLoad];

    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Annula" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = button;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        self.navigationItem.titleView = customTitle;
    }
    else{
        self.title = @"Richiedi informazioni";
    }
    
    //se sono necessari 2 pulsanti
    /*if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        cancelButton = [[UIButton alloc] init];
        UIImage* buttonImage = [[UIImage imageNamed:@"normal_button_big.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
        
        UIImage* buttonPressedImage = [[UIImage imageNamed:@"normal_button_big_selected.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0.0, 0.0, 150.0, buttonImage.size.height);
        [cancelButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
        [cancelButton setTitle:@"Annulla" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:cancelButton];
        [self setButtonsInView];
    }*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void) setButtonsInView{
    
    float middleView = self.navigationController.navigationBar.frame.size.width/2;
    float offsetFromMiddle = middleView - 45;
    float buttonWidth = sendButton.frame.size.width;
    float x = 0.0f;
    
    x = offsetFromMiddle - buttonWidth;
    
    cancelButton.frame = CGRectMake(x,BUTTON_Y, cancelButton.frame.size.width, cancelButton.frame.size.height);
    
    offsetFromMiddle = middleView + 45;
    x = offsetFromMiddle;
    
    sendButton.frame = CGRectMake(x,BUTTON_Y,sendButton.frame.size.width,sendButton.frame.size.height);
}
*/

#pragma mark - UITextFieldDelegate

- (void) textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    //nslog(@"2) dataKey %@", dataKey);
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
           // //nslog(@"mostra avviso completa tutti i campi");
            reason = @"Per favore compila tutti i campi richiesti";
            isValid = FALSE;
            
        }
        else {
            if([allTrim(iva) length] < 11){
                reason = @"Per favore inserisci 11 cifre per la partita IVA";
                isValid = FALSE;

            }
            if([allTrim(modello) length] <= 1) {
                reason = @"Per favore inserisci un modello di auto valido";
                isValid = FALSE;
            }
            if([allTrim(marca) length] <= 1) {
                reason = @"Per favore inserisci una marca di auto valida";
                isValid = FALSE;
            }
        }
    }
    else{
        if([allTrim(tipo) length] == 0|| [allTrim(prezzo) length] == 0){
            //NSLog(@"mostra avviso completa tutti i campi");
            reason = @"Per favore compila tutti i campi richiesti";
            isValid = FALSE;
            
        }
        else{
            if([allTrim(tipo) length] <= 2) {
                reason = @"Per favore inserisci una tipologia elettromedicale valida";
                isValid = FALSE;
            }
            if([allTrim(prezzo) length] <= 1) {
                reason = @"Per favore inserisci un prezzo di 2 o più cifre ";
                isValid = FALSE;
            }
            BOOL valid;
            NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
            NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:prezzo];
            valid = [alphaNums isSupersetOfSet:inStringSet];
            if (!valid){
                reason = @"Per favore inserisci solo cifre per il prezzo";
                isValid = FALSE;
            }
        }
    }
    if([allTrim(ragSoc) length] == 0|| [allTrim(phone) length] == 0 ||
       [allTrim(citta) length] == 0){
       // //nslog(@"mostra avviso completa tutti i campi");
        reason = @"Per favore compila tutti i campi richiesti";
        isValid = FALSE;
        
    }
    else{
        if([allTrim(ragSoc) length] <= 3) {
            reason = @"Per favore inserisci una ragione sociale valida";
            isValid = FALSE;
        }
        if([allTrim(phone) length] <= 7) {
            reason = @"Per favore inserisci un numero di telefono valido";
            isValid = FALSE;
        }
        if([allTrim(citta) length] <= 2) {
            reason = @"Per favore inserisci una città valida";
            isValid = FALSE;
        }
        if (![Utilities isNumeric:replaceSpace(phone)]) {
           // //nslog(@"mostra avviso telefono errato");
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
        //NSLog(@"mostra alert");
        
        UIAlertView *alertView = [[UIAlertView alloc]init];
        alertView.title = reason;
        [alertView setCancelButtonIndex:0];
        [alertView setCancelButtonIndex:[alertView addButtonWithTitle:@"OK"]];
        [alertView show];
    }
        
    return  isValid;
}

#define IVA_MAX_LENGHT 11

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if([dataKey isEqualToString:@"iva"]){
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
            return newLength <= IVA_MAX_LENGHT || returnKey;
        }
    return YES;
    
}

-(NSString*)createHtmlBody{
 
    NSString *body = [NSString stringWithFormat:@"Richiesta informazioni <br><br><b>Ragione sociale</b>: %@ <br><b>Cellulare</b> = %@ <br><b>E-mail</b>: %@ <br><b>Città</b>: %@",ragSoc,phone,email,citta];
    
    if ([self.kind isEqualToString:@"noleggioAuto"]) {
        body = [NSString stringWithFormat:@"%@ <br><b>Partita iva</b>: %@ <br><b>Marca dell'auto da quotare</b>: %@ <br><b>Modello auto</b>: %@",body,iva,marca,modello];
    }
    else{
        body = [NSString stringWithFormat:@"%@ <br><b>Tipologia elettromedicale</b>: %@ <br><b>Prezzo imponibile</b>: %@",body,tipo,prezzo];
    }
    
    return body;
}

-(void)sendRequest{
    [super sendRequest];
    if([self.kind isEqualToString:@"noleggioAuto"])
        [PDHTTPAccess sendEmail:[self createHtmlBody] object:@"Richiesta noleggio" address:NOLEGGIO_MAIL delegate:self];
    else
        [PDHTTPAccess sendEmail:[self createHtmlBody] object:@"Richiesta leasing" address:LEASING_MAIL delegate:self];
    [Utilities logEvent:[NSString stringWithFormat:@"Richiesta_%@_inviata",self.kind] arguments:nil];
}

#pragma mark - ErrorView methods
#pragma mark - ErrorView methods
-(void)hideErrorView:(UITapGestureRecognizer*)gesture{
    if(errorView || errorView.showed){
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             [errorView setFrame:CGRectMake(0, errorView.frame.origin.y, errorView.frame.size.width,0)];
                         }
         ];
        errorView.showed = NO;
    }
}

-(void)showErrorView:(NSString*)message{
    //nslog(@"CIAOOOO");
    float y = self.navigationController.navigationBar.frame.size.height;
    if(errorView == nil || !errorView.showed){
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            errorView = [[ErrorView alloc] init];
            y = 63;
        }
        else{
            errorView = [[ErrorView alloc] initWithSize:self.view.frame.size];
        }
        errorView.label.text = message;
        [errorView.tapRecognizer addTarget:self action:@selector(hideErrorView:)];
        
        CGRect oldFrame = [errorView frame];
        //se il controller è in modalView non capisco perchè non vale la stessa y per l'origin
        // e devo fixarla a mano.. CONTROLLARE
        [errorView setFrame:CGRectMake(0, y, oldFrame.size.width, 0)];
        
        [self.navigationController.view addSubview:errorView];
        
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             [errorView setFrame:CGRectMake(0,y, oldFrame.size.width, oldFrame.size.height)];
                             //nslog(@"ORIGIN Y = %f", errorView.frame.origin.y);
                         }
         ];
        errorView.showed = YES;
    }
    
}
@end
