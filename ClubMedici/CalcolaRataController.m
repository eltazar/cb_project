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
    NSInteger tassoSelezionato;
    NSInteger numeroRateSelezionato;
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
     self.view.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];
    // Do any additional setup after loading the view from its nib.
    listaTasso = [NSArray arrayWithObjects:@"Ordinario 9,90",@"Ridotto 4,45",@"Zero 0", nil];
    tassoSelezionato = 0;
    listaNumeroRate = [NSArray arrayWithObjects:@"6",@"12",@"18",@"24",@"30",@"36",@"42",@"48",@"54",@"60", nil];
    numeroRateSelezionato = 0;    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)scegliTassoButton:(UIControl*)sender{
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    //se attivo aggiorno assicurazione
    _assicurazioneField.text = [NSString stringWithFormat:@"%.2f",[self calcolaAssicurazione:newString tag:textField.tag]];
    
    _totaleField.text = [NSString stringWithFormat:@"%.2f",[self calcolaTotale:newString tag:textField.tag]];
    
    return YES;
}

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

-(float)calcolaAssicurazione:(NSString*)text tag:(int)tag{
    
    if(tag == _importoRichiestoField.tag){
        return ([text intValue] + [_speseField.text intValue]) * (4.20f/100.0f);
    }
    else if (tag == _speseField.tag){
        return ([_importoRichiestoField.text intValue] + [text intValue]) * (PERCENTUALE_ASSICURAZIONE/100.0f);
    }
    return 0.0f;
}

-(float)calcolaTotale:(NSString*)text tag:(int)tag{
    
    if(tag == _importoRichiestoField.tag){
        return [text floatValue]+[_assicurazioneField.text floatValue]+[_speseField.text floatValue];

    }
    else if (tag == _speseField.tag){
        return [_importoRichiestoField.text floatValue]+[_assicurazioneField.text floatValue]+[text floatValue];
    }
    return 0.0f;
}

@end
