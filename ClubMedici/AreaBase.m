//
//  AreaBase.m
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaBase.h"
#import "WMTableViewDataSource.h"

@implementation AreaBase

-(id) initWithJson:(NSDictionary*)json{

    self = [self init];
    if(self){
        self.descrizione = [json objectForKey:@"testo"];
        self.titolo = [json objectForKey:@"menu"];
        self.email1 = [json objectForKey:@"email"];
        self.tel = [json objectForKey:@"telefono"];
        self.titolo = @"Area finanziaria";
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"AREA BASE ALLOCATO");
    }
    return self;
}

- (WMTableViewDataSource *)getDataModel {
    return [[WMTableViewDataSource alloc] initWithArray: [self _getDataModelArray]];
}

# pragma mark - Private Methods

- (NSMutableArray *)_getDataModelArray {
    /*
     STRUTTURA:
     
     ARRAY DI SEZIONI (NSDictionary):
     k: SECTION_NAME -> v: titolo della sezione
     k: SECTION_DESCRIPTION -> v: array di dizionari per ogni riga della sezione
     
     ogni elemento elemento dell'array SECTION_DESCRIPTION rappresenta una riga è un dizionario.
     Come esempio, SECTION_DESCRIPTION è strutturato esattamente come self.pdfList
     */
    
    // Data model totale
    NSMutableArray *dataModel = [[NSMutableArray alloc] init];
    
    // Dati per la sezione 0
    NSMutableDictionary *informazioni    = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSMutableArray *informazioniContents = [[NSMutableArray alloc] initWithCapacity:4];
    
    if(self.descrizione)
        [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"description",         @"DATA_KEY",
                                         self.descrizione,       @"LABEL", nil]];
    if(self.tel)
        [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"phone",              @"DATA_KEY",
                                         self.tel,              @"LABEL", nil]];
    if(self.email1)
        [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"email",              @"DATA_KEY",
                                         self.email1,           @"LABEL", nil]];
    if(self.email2)
        [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"email",              @"DATA_KEY",
                                         self.email2,           @"LABEL", nil]];
    
    [informazioni setObject:@"Informazioni"         forKey:@"SECTION_NAME"];
    [informazioni setObject:informazioniContents    forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:informazioni];
    
    // Dati per la sezione 1
    if (self.itemList) {
        NSMutableDictionary *documenti = [[NSMutableDictionary alloc] initWithCapacity:2];
        [documenti setObject:@"Servizi"  forKey:@"SECTION_NAME"];
        [documenti setObject:self.itemList forKey:@"SECTION_CONTENTS"];
        [dataModel addObject:documenti];
    }
    
    return dataModel;
}

@end
