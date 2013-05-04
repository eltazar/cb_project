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

@property(nonatomic, strong) IBOutlet FXLabel *scegliTasso;
@property(nonatomic, strong) IBOutlet FXLabel *importoRichiesto;
@property(nonatomic, strong) IBOutlet FXLabel *spese;
@property(nonatomic, strong) IBOutlet FXLabel *assicurazione;
@property(nonatomic, strong) IBOutlet FXLabel *importoRata;
@property(nonatomic, strong) IBOutlet FXLabel *totale;
@property(nonatomic, strong) IBOutlet FXLabel *numeroRate;
@property(nonatomic, strong) IBOutlet FXLabel *footer;

@property(nonatomic, strong) IBOutlet UITextField *tassoField;
@property(nonatomic, strong) IBOutlet UITextField *importoRichiestoField;
@property(nonatomic, strong) IBOutlet UITextField *speseField;
@property(nonatomic, strong) IBOutlet UITextField *assicurazioneField;
@property(nonatomic, strong) IBOutlet UITextField *importoRataField;
@property(nonatomic, strong) IBOutlet UITextField *totaleField;
@property(nonatomic, strong) IBOutlet UITextField *numeroRateField;

-(IBAction)scegliTassoButton:(UIControl*)sender;
-(IBAction)scegliNumeroRate:(UIControl*)sender;
@end
