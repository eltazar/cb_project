//
//  AreaCureMediche.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaCureMediche.h"

@implementation AreaCureMediche

-(id)init{
    
    self = [super init];
    if (self) {
        // dati dummy
        self.titolo = @"Cure mediche rateali";
        self.descrizione = @"Il finanziamento per cure sanitarie a rimborso rateale è un credito personale che anticipa le parcelle ai medici permettendo ai pazienti di rateizzare i costi di cure odontoiatriche, di medicina estetica, di chirurgia generale a condizioni agevolate";
        
        self.img =@"xxxxx";
        self.tel = @"06/8607891";
        self.email = @"prestiti@clubmedici.it";
        
        //SUPPONENDO CHE I LINK PDF LI STRUTTURIAMO COSì DOPO LA QUERY
        //array di dati per la sezione 1
        self.pdfList = [[NSMutableArray alloc] init];
        [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link1",@"Titolo1", nil]];
        [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link2",@"Titolo2", nil]];
        [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link3",@"Titolo3", nil]];
        
    }
    return self;
}

@end
