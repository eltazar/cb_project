//
//  CalcolaRataController.h
//  ClubMedici
//
//  Created by mario on 04/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXLabel.h"

@interface CalcolaRataController : UIViewController <UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet FXLabel *scegliTasso;
@property(nonatomic, weak) IBOutlet FXLabel *importoRichiesto;
@property(nonatomic, weak) IBOutlet FXLabel *spese;
@property(nonatomic, weak) IBOutlet FXLabel *assicurazione;
@property(nonatomic, weak) IBOutlet FXLabel *importoRata;
@property(nonatomic, weak) IBOutlet FXLabel *totale;
@property(nonatomic, weak) IBOutlet FXLabel *numeroRate;
@property(nonatomic, weak) IBOutlet FXLabel *footer;

@property(nonatomic, weak) IBOutlet UITextField *tassoField;
@property(nonatomic, weak) IBOutlet UITextField *importoRichiestoField;
@property(nonatomic, weak) IBOutlet UITextField *speseField;
@property(nonatomic, weak) IBOutlet UITextField *assicurazioneField;
@property(nonatomic, weak) IBOutlet UITextField *importoRataField;
@property(nonatomic, weak) IBOutlet UITextField *totaleField;
@property(nonatomic, weak) IBOutlet UITextField *numeroRateField;
@property(nonatomic, weak) IBOutlet UIButton *calcolaButton;

-(IBAction)scegliTassoButton:(UIControl*)sender;
-(IBAction)scegliNumeroRate:(UIControl*)sender;

@end
