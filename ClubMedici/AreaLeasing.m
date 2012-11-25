//
//  AreaLeasing.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaLeasing.h"
#import "WMTableViewDataSource.h"

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
        self.itemList = [[NSArray alloc] initWithObjects:
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"pdf",            @"DATA_KEY",
                                     @"Titolo 1",       @"LABEL",
                                     @"url/ciao.it",    @"URL", nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"pdf",            @"DATA_KEY",
                                     @"Titolo 2",       @"LABEL",
                                     @"url/ciao.it",    @"URL", nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"pdf",            @"DATA_KEY",
                                     @"Titolo 3",       @"LABEL",
                                     @"url/ciao.it",    @"URL", nil], nil];
    }
    return self;
}

- (NSMutableArray *)_getDataModelArray {
    // Data model totale
    NSMutableArray *dataModel = [super _getDataModelArray];
    
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
    
    return dataModel;
}

@end
