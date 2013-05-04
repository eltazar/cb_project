//
//  CalcolaRataController.h
//  ClubMedici
//
//  Created by mario on 04/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalcolaRataController : UIViewController <UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet UILabel *titolo;
@property(nonatomic, strong) IBOutlet UILabel *importoRichiesto;
@property(nonatomic, strong) IBOutlet UILabel *spese;
@property(nonatomic, strong) IBOutlet UILabel *assicurazione;
@property(nonatomic, strong) IBOutlet UILabel *importoRata;
@property(nonatomic, strong) IBOutlet UILabel *totale;
@property(nonatomic, strong) IBOutlet UILabel *numeroRate;

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
