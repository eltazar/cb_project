//
//  AreaFinanziaria.m
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaFinanziaria.h"
#import "WMTableViewDataModel.h"

@implementation AreaFinanziaria
@synthesize emailMutuo,emailPrestito;

-(id)init{
    
    self = [super init];
    if (self) {
        NSLog(@"AREA FINANZ ALLOCATO");
        // dati dummy
        self.titolo = @"Area finanziaria";
        self.descrizione = @"L’area finanziaria di Club Medici è costituita da un team di specialisti informati e disponibili, pronti a consigliare l’offerta più adatta alle vostre necessità e a seguirvi, passo dopo passo, nel corso del processo di approvazione della vostra richiesta.\n L’area finanziaria di Club Medici offre servizio di consulenza per: mutui, prestiti personali e cessione del quinto per medici ospedalieri, di base, pediatri, sumaisti e pensionati. ";
        
        self.img =@"xxxxx";
        self.tel = @"06/8607891";
        self.emailPrestito = @"prestiti@clubmedici.it";
        self.emailMutuo = @"mutui@clubmedici.it";
        
        //SUPPONENDO CHE I LINK PDF LI STRUTTURIAMO COSì DOPO LA QUERY
        //array di dati per la sezione 1
        self.pdfList = [[NSMutableArray alloc] init];
        [self.pdfList insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"pdf",             @"DATA_KEY",
                                    @"Titolo 1",        @"LABEL",
                                    @"url/ciao.it",     @"URL",
                                    nil] atIndex: 0];
        [self.pdfList insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"pdf",             @"DATA_KEY",
                                    @"Titolo 2",        @"LABEL",
                                    @"url/ciao.it",     @"URL",
                                    nil] atIndex: 1];
        [self.pdfList insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"pdf",             @"DATA_KEY",
                                    @"Titolo 3",        @"LABEL",
                                    @"url/ciao.it",     @"URL",
                                    nil] atIndex: 2];

    }
    return self;
}

- (WMTableViewDataModel *)getDataModel{
    /*
     STRUTTURA:
     
     ARRAY DI SEZIONI (NSDictionary):
                k: SECTION_NAME -> v: titolo della sezione
                k: SECTION_DESCRIPTION -> v: array di dizionari per ogni riga della sezione
     
     ogni elemento elemento dell'array SECTION_DESCRIPTION rappresenta una riga è un dizionario.
     Come esempio, SECTION_DESCRIPTION è strutturato esattamente come self.pdfList
     */
    
    // Data model totale
    NSMutableArray *dataModel = [[NSMutableArray alloc] initWithCapacity:2];
    
    // Dati per la sezione 0
    NSMutableDictionary *informazioni    = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSMutableArray *informazioniContents = [[NSMutableArray alloc] initWithCapacity:4];
   
    if(self.descrizione != nil) 
        [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"description",         @"DATA_KEY",
                                        self.descrizione,       @"LABEL", nil]];
    if(self.tel != nil)
        [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"phone",              @"DATA_KEY",
                                         self.tel,              @"LABEL", nil]];
    if(self.emailMutuo != nil)
        [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"email",              @"DATA_KEY",
                                         self.emailMutuo,       @"LABEL", nil]];
    if(self.emailPrestito != nil)
        [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"email",              @"DATA_KEY",
                                         self.emailPrestito,    @"LABEL", nil]];
    
    [informazioni setObject:@"Informazioni"         forKey:@"SECTION_NAME"];
    [informazioni setObject:informazioniContents    forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:informazioni];
        
    // Dati per la sezione 1
    NSMutableDictionary *documenti = [[NSMutableDictionary alloc] initWithCapacity:2];
    [documenti setObject:@"Documenti" forKey:@"SECTION_NAME"];
    [documenti setObject:self.pdfList forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:documenti];
    
    return [[WMTableViewDataModel alloc] initWithArray: dataModel];
}

@end
