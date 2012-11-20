//
//  AreaFinanziaria.m
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaFinanziaria.h"

@implementation AreaFinanziaria
@synthesize numeroDiPdf, pdfList;

-(id)init{
    
    self = [super init];
    if (self) {
        // dati dummy
        self.titolo = @"Area finanziaria";
        self.descrizione = @"L’area finanziaria di Club Medici è costituita da un team di specialisti informati e disponibili, pronti a consigliare l’offerta più adatta alle vostre necessità e a seguirvi, passo dopo passo, nel corso del processo di approvazione della vostra richiesta.\n L’area finanziaria di Club Medici offre servizio di consulenza per: mutui, prestiti personali e cessione del quinto per medici ospedalieri, di base, pediatri, sumaisti e pensionati. ";
        
        self.img =@"xxxxx";
        self.tel = @"06/8607891";
        self.email = @"prestiti@clubmedici.it";
        numeroDiPdf = 3;
    }
    return self;
}

@end
