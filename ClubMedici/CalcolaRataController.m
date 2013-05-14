//
//  CalcolaRataController.m
//  ClubMedici
//
//  Created by mario on 04/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "CalcolaRataController.h"
#import "ActionSheetPicker.h"

#define KEYBOARD_ORIGIN_Y self.view.frame.size.height - 216.0f

#define TASSO_PICKER_TAG 55
#define NUMERO_RATE_PICKER_TAG 60
#define PERCENTUALE_ASSICURAZIONE 4.20f


@interface CalcolaRataController ()
{
    NSArray *listaTasso;
    NSArray *listaNumeroRate;
    int tassoSelezionato;
    int numeroRateSelezionato;

    double tasso;
    int numeroRate;
    double importoRichiesto;
    double spesePratica;
    double monthlyRate;
    double assicurazione;
    double totalePrestito;
}
@end

@implementation CalcolaRataController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Simulatore rate";
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0f green:244/255.0f blue:245/255.0f alpha:1];
    // Do any additional setup after loading the view from its nib.
    listaTasso = [NSArray arrayWithObjects:@"Ordinario 9.90",@"Ridotto 4.45",@"Zero 0", nil];
    tassoSelezionato = 0;
    listaNumeroRate = [NSArray arrayWithObjects:@"6",@"12",@"18",@"24",@"30",@"36",@"42",@"48",@"54",@"60", nil];
    numeroRateSelezionato = 0;
    
    [self applyLabelEffect:_importoRata];
    [self applyLabelEffect:_importoRichiesto];
    [self applyLabelEffect:_numeroRate];
    [self applyLabelEffect:_scegliTasso];
    [self applyLabelEffect:_numeroRate];
    [self applyLabelEffect:_assicurazione];
    [self applyLabelEffect:_totale];
    [self applyLabelEffect:_spese];
    [self applyLabelEffect:_footer];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UISwipeGestureRecognizer *swipeGestue = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBackWithSwipe:)];
        [swipeGestue setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:swipeGestue];
    }
    
    UIImage* buttonImage = [[UIImage imageNamed:@"normal_button_big.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    UIImage* buttonPressedImage = [[UIImage imageNamed:@"normal_button_big_selected.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    [_calcolaButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_calcolaButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return YES;
    }
    else return NO;
}

-(void)applyLabelEffect:(FXLabel*)label{
    label.textColor = [UIColor colorWithWhite:0.5f alpha:1];
    label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    label.shadowOffset = CGSizeMake(0.8f, 0.80f);
    label.shadowBlur = 1.0f;
    label.innerShadowBlur = 3.0f;
    label.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
    label.innerShadowOffset = CGSizeMake(0.8f, 0.8f);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)scegliTassoButton:(UIControl*)sender{
    [self.view endEditing:YES];
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
            tassoSelezionato = selectedIndex;
        }

    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    
    [ActionSheetStringPicker showPickerWithTitle:@"Scegli tasso" rows:listaTasso initialSelection:tassoSelezionato doneBlock:done cancelBlock:cancel origin:_tassoField];
    
    NSLog(@"SENDER = %@, VIEW = %@",sender,self.view);
}

-(IBAction)scegliNumeroRate:(UIControl*)sender{
    [self.view endEditing:YES];
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
            numeroRateSelezionato = selectedIndex;
        }
        
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    [ActionSheetStringPicker showPickerWithTitle:@"Numero di rate" rows:listaNumeroRate initialSelection:numeroRateSelezionato doneBlock:done cancelBlock:cancel origin:sender];
}

#pragma mark - UITextFieldDelegate

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if(textField.tag == NUMERO_RATE_PICKER_TAG || textField.tag == TASSO_PICKER_TAG)
        return NO;
    else return YES;
}

//per annullare editing cliccando ovunque nella view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
}

/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    //se attivo aggiorno assicurazione
    _assicurazioneField.text = [NSString stringWithFormat:@"%.2f",[self calcolaAssicurazione:newString tag:textField.tag]];
    
    _totaleField.text = [NSString stringWithFormat:@"%.2f",[self calcolaTotale:newString tag:textField.tag]];
    
    return YES;
}*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // called when "Next" is pressed
    
    if(textField.tag == 40){
        [_speseField becomeFirstResponder];
    }
    else if(textField.tag == 41){
        [textField resignFirstResponder];
        [self scegliNumeroRate:_numeroRateField];
    }    
    return YES;
}

#pragma mark - Private methods

-(void)calcolaAssicurazione{
    assicurazione = (importoRichiesto + spesePratica) * (PERCENTUALE_ASSICURAZIONE/100.0f);
    _assicurazioneField.text = [NSString stringWithFormat:@"%.2f",assicurazione];
}

-(void)calcolaTotale{
    totalePrestito = importoRichiesto + spesePratica + assicurazione;
    _totaleField.text = [NSString stringWithFormat:@"%.2f",totalePrestito];
}

//http://stackoverflow.com/questions/9721462/how-to-calculate-loan-repayment
-(IBAction)loanCalculator:(id)sender{
    
    [self.view endEditing:YES];

    spesePratica = [_speseField.text doubleValue];
    importoRichiesto = [_importoRichiestoField.text doubleValue];
    numeroRate = [_numeroRateField.text intValue];
    [self setTasso];

    
    if(importoRichiesto == 0 || numeroRate == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Inserisci l'importo del prestito e il numero di rate" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    [self calcolaAssicurazione];
    [self calcolaTotale];

    if(tasso == 0){
        monthlyRate = totalePrestito / numeroRate;
    }
    else{
        //assicurazione calcolata su importo + spese
        [self calcolaAssicurazione];
        [self calcolaTotale];

        double loan = totalePrestito;
        //NSLog(@"TASSO = %f",tasso);
        double annualInterestRate = tasso; // 6%
        annualInterestRate = annualInterestRate /100.0f; // 0.06 i.e. 6%
        int numberOfPayments = numeroRate;

        // (loan * (interest / 12)) / (1 - (1 + interest / 12) ^ -number)
        //          ^^^^^^^^^^^^^ temp1
        // ^^^^^^^^^^^^^^^^^^^^^^^^ temp2
        //                                      ^^^^^^^^^^^^^ temp1
        //                                 ^^^^^^^^^^^^^^^^^^^ temp4
        //                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ temp5
        //                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ temp6
        double temp1 = annualInterestRate / 12;
        double temp2 = (temp1 * loan); 
        double temp4 = 1.0 + temp1;
        double temp5 = 1.0 / pow(temp4,numberOfPayments);
        double temp6 = 1.0 - temp5;

        monthlyRate = temp2 / temp6;
    }
    _importoRataField.text = [NSString stringWithFormat:@"%.2f",monthlyRate];
}

-(void)setTasso{
    
    switch (tassoSelezionato) {
        case 0:
            tasso = 9.9f;
            break;
        case 1:
            tasso = 4.9f;
            break;
        case 2:
            tasso = 0.0f;
            break;
        default:
            tasso = 9.9f;
            break;
    }
}

-(void)goBackWithSwipe:(UISwipeGestureRecognizer*)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
