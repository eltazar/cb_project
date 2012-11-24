//
//  RichiestaIscrizioneControllerViewController.h
//  ClubMedici
//
//  Created by mario greco on 23/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "FormViewController.h"

@interface RichiestaNoleggioController : FormViewController

@property(nonatomic, strong) NSString *kind;

-(id) init:(NSString*)kindRequest;

@end
