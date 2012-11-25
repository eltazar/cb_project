//
//  AreaFinanziaria.m
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaFinanziaria.h"
#import "WMTableViewDataSource.h"

@implementation AreaFinanziaria

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"AREA FINANZ ALLOCATO");
        // dati dummy
        self.titolo = @"Area finanziaria";
        self.descrizione = @"L’area finanziaria di Club Medici è costituita da un team di specialisti informati e disponibili, pronti a consigliare l’offerta più adatta alle vostre necessità e a seguirvi, passo dopo passo, nel corso del processo di approvazione della vostra richiesta.\n L’area finanziaria di Club Medici offre servizio di consulenza per: mutui, prestiti personali e cessione del quinto per medici ospedalieri, di base, pediatri, sumaisti e pensionati. ";
        
        self.img =@"xxxxx";
        self.tel = @"06/8607891";
        self.email1 = @"prestiti@clubmedici.it";
        self.email2 = @"mutui@clubmedici.it";
        
        //SUPPONENDO CHE I LINK PDF LI STRUTTURIAMO COSì DOPO LA QUERY
        //array di dati per la sezione 1
        self.itemList = [[NSArray alloc] initWithObjects:
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"pdf",             @"DATA_KEY",
                                    @"Titolo 1",        @"LABEL",
                                    @"url/ciao.it",     @"URL", nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"pdf",             @"DATA_KEY",
                                    @"Titolo 2",        @"LABEL",
                                    @"url/ciao.it",     @"URL", nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"pdf",             @"DATA_KEY",
                                    @"Titolo 3",        @"LABEL",
                                    @"url/ciao.it",     @"URL", nil], nil];

    }
    return self;
}



@end
