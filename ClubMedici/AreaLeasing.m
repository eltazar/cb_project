//
//  AreaLeasing.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaLeasing.h"
#import "WMTableViewDataModel.h"

@implementation AreaLeasing

- (id)init {
    self = [super init];
    if (self) {
        
        NSLog(@"AREA LEASING ALLOCATO");
        // dati dummy
        self.titolo = @"Leasing e noleggio";
        self.descrizione = @"Doctor Leasing è un qualificato servizio di consulenza che assiste i soci nell'accesso ad un leasing - elettromedicale, auto, strumentale, immobiliare, nautico -, attraverso la semplificazione delle procedure e la valutazione della migliore offerta sul mercato.\n Il noleggio auto, elettromedicale e strumentale è un ottimo servizio per avere sempre auto ed elettromedicali nuovi e liberarsi la mente. ";
        
        self.img =@"xxxxx";
        self.tel = @"06/8607891";
        
        //SUPPONENDO CHE I LINK PDF LI STRUTTURIAMO COSì DOPO LA QUERY
        //array di dati per la sezione 1
        self.pdfList = [[NSMutableArray alloc] init];
        [self.pdfList insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"pdf",            @"DATA_KEY",
                                     @"Titolo 1",       @"LABEL",
                                     @"url/ciao.it",    @"URL",
                                     nil] atIndex: 0];
        [self.pdfList insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"pdf",            @"DATA_KEY",
                                     @"Titolo 2",       @"LABEL",
                                     @"url/ciao.it",    @"URL",
                                     nil] atIndex: 1];
        [self.pdfList insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"pdf",            @"DATA_KEY",
                                     @"Titolo 3",       @"LABEL",
                                     @"url/ciao.it",    @"URL",
                                     nil] atIndex: 2];
        
    }
    return self;
}

- (WMTableViewDataModel *)getDataModel {
    /*
     STRUTTURA:
     
     DIZIONARIO DATA MODEL:
     k -> sections
     v -> titolo delle sezioni
     k -> data
     v -> array di dati per ogni sezione
     
     per la chiave DATA: ho array tale che:
     indice 0 -> sezione 0:
     elementi sono stringhe come: descrizione, telefono,  mail....
     indice 1 -> sezione 1:
     elementi sono dizionari: k -> titolo del link
                              v -> url
     indice 2 -> sezione 2:
     array di stringhe
     */
    
    
    // Data model totale
    NSMutableArray *dataModel = [[NSMutableArray alloc] initWithCapacity:3];
    
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
    
    [informazioni setObject:@"Informazioni"         forKey:@"SECTION_NAME"];
    [informazioni setObject:informazioniContents    forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:informazioni];
    
    // Dati per la sezione 1
    NSMutableDictionary *documenti = [[NSMutableDictionary alloc] initWithCapacity:2];
    [documenti setObject:@"Documenti" forKey:@"SECTION_NAME"];
    [documenti setObject:self.pdfList forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:documenti];
    
        
    // Dati per la sezione 2
    NSMutableDictionary *preventivo    = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSMutableArray *preventivoContents = [[NSMutableArray alloc] initWithCapacity: 3];
    
    [preventivoContents insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                            @"noleggioAuto",                @"DATA_KEY",
                            @"Noleggio auto",               @"LABEL",
                            nil] atIndex: 0];
    [preventivoContents insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                            @"noleggioElettro",             @"DATA_KEY",
                            @"Noleggio elettromedicale",    @"LABEL",
                            nil] atIndex: 1];
    [preventivoContents insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                            @"leasingElettro",              @"DATA_KEY",
                            @"Leasing elettromedicale",     @"LABEL",
                            nil] atIndex: 2];
    
    [preventivo setObject:@"Richiesta Preventivo"   forKey:@"SECTION_NAME"];
    [preventivo setObject:preventivoContents        forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:preventivo];
    
    
    return [[WMTableViewDataModel alloc] initWithArray: dataModel];
}

@end
