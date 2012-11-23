//
//  AreaLeasing.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaLeasing.h"

@implementation AreaLeasing

-(id)init{
    
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
                                     @"pdf",    @"DataKey",
                                     @"Titolo 1",   @"label",
                                     @"url/ciao.it",  @"url",
                                     nil] atIndex: 0];
        [self.pdfList insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"pdf",    @"DataKey",
                                     @"Titolo 2",   @"label",
                                     @"url/ciao.it",  @"url",
                                     nil] atIndex: 1];
        [self.pdfList insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"pdf",    @"DataKey",
                                     @"Titolo 3",   @"label",
                                     @"url/ciao.it",  @"url",
                                     nil] atIndex: 2];
        
    }
    return self;
}

-(NSMutableDictionary *) getDataModel{
    
    
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
    
    
    //data model totale
    NSMutableDictionary *dataModel = [[NSMutableDictionary alloc] init];
    
    //array di dati  per le varie sezioni
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:3];
    
    //array di titoli sezione
    [dataModel setObject:[NSArray arrayWithObjects:@"Informazioni",@"Documenti",@"Richiesta preventivo", nil] forKey:@"sections"];
    
    //array di dati per la sezione 0
    NSMutableArray *info = [[NSMutableArray alloc] init];
    
    if(self.descrizione != nil){
        [info insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                            @"description",    @"DataKey",
                            self.descrizione,   @"label",
                            nil] atIndex: 0];
    }
    
    if(self.tel != nil){
        [info insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                            @"phone",    @"DataKey",
                            self.tel,   @"label",
                            nil] atIndex: 1];
    }
    
    [data insertObject:info atIndex:0];
    
    //array di dati per la sezione 1
    [data insertObject:self.pdfList atIndex:1];
    
    
    //array di dati per la sezione 2
    NSMutableArray *preventivo = [[NSMutableArray alloc] initWithCapacity:3];
    [preventivo addObject:@"Noleggio auto"];
    [preventivo addObject:@"Noleggio elettromedicale"];
    [preventivo addObject:@"Leasing elettromedicale"];
    
    NSMutableArray *tipoRichieste = [[NSMutableArray alloc] init];
    
    [tipoRichieste insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                            @"noleggioAuto",    @"DataKey",
                            @"Noleggio auto",   @"label",
                            nil] atIndex: 0];
    [tipoRichieste insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"noleggioElettro",    @"DataKey",
                                 @"Noleggio elettromedicale",   @"label",
                                 nil] atIndex: 1];
    
    [tipoRichieste insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"leasingElettro",    @"DataKey",
                                 @"Leasing elettromedicale",   @"label",
                                 nil] atIndex: 2];
    
    
    
    [data insertObject:tipoRichieste atIndex:2];
    
    [dataModel setObject:data forKey:@"data"];
    
    NSLog(@"DATA MODEL = %@",dataModel);
    
    return dataModel;
}

@end
