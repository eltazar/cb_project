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

-(id) initWithJson:(NSArray*)json{

    self = [self init];
    if(self){
        
        //Oggetto in posizione 0 è il record che descrive l'area
        NSDictionary *descArray = [json objectAtIndex:0];
        
        //controllo se stringa proveniente dal db è NULL
        if(! [[descArray objectForKey:@"testo"]isKindOfClass:[NSNull class]])
            self.descrizione = [descArray objectForKey:@"testo"];
       
        if(! [[descArray objectForKey:@"menu"]isKindOfClass:[NSNull class]])
            self.titolo = [descArray objectForKey:@"menu"];
        
        [self splitEmails:[descArray objectForKey:@"email"]];
       
        if(! [[descArray objectForKey:@"telefono"]isKindOfClass:[NSNull class]])
            self.tel = [descArray objectForKey:@"telefono"];
        
        if(! [[descArray objectForKey:@"fotohd"]isKindOfClass:[NSNull class]])
            self.img = [descArray objectForKey:@"fotohd"];
        
        //Gli oggetti seguenti, se presenti, sono la lista di documenti dell'area
        _itemList = [[NSMutableArray alloc] init];
        for(int i = 1; i < json.count ; i++){
            //aggiungo uno ad uno all'array
            //[_itemList addObject:[json objectAtIndex:i]];
            
            NSDictionary *dict = [json objectAtIndex:i];
            
            //creo l'oggetto per la riga della tabella
            NSDictionary *item = [[NSDictionary alloc] initWithObjectsAndKeys:
             @"documentoArea",             @"DATA_KEY",
             [dict objectForKey:@"menu"],        @"LABEL",
             [dict objectForKey:@"id_pagina"],     @"ID_PAG",
            [dict objectForKey:@"id_sottomenu"],   @"ID_SOTTOMENU",nil];  
            
            [_itemList addObject: item];     
        }
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        //NSLog(@"AREA BASE ALLOCATO");
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.titolo forKey:@"titolo"];
    [encoder encodeObject:self.descrizione forKey:@"descrizione"];
    [encoder encodeObject:self.img forKey:@"img"];
    [encoder encodeObject:self.tel forKey:@"tel"];
    [encoder encodeObject:self.email1 forKey:@"email1"];
    [encoder encodeObject:self.email2 forKey:@"email2"];
    [encoder encodeObject:self.itemList forKey:@"itemList"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.titolo = [decoder decodeObjectForKey:@"titolo"];
        self.descrizione = [decoder decodeObjectForKey:@"descrizione"];
        self.img = [decoder decodeObjectForKey:@"img"];
        self.tel = [decoder decodeObjectForKey:@"tel"];
        self.email1 = [decoder decodeObjectForKey:@"email1"];
        self.email2 = [decoder decodeObjectForKey:@"email2"];
        self.itemList = [decoder decodeObjectForKey:@"itemList"];
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
    if (self.itemList && self.itemList.count > 0) {
        NSMutableDictionary *documenti = [[NSMutableDictionary alloc] initWithCapacity:2];
        [documenti setObject:@"Servizi"  forKey:@"SECTION_NAME"];
        [documenti setObject:self.itemList forKey:@"SECTION_CONTENTS"];
        [dataModel addObject:documenti];
    }
    
    return dataModel;
}

-(void)splitEmails:(NSString*) doubleMail{
    
    //TODO: fare con regex, è meglio...
    NSArray *emails = nil;
    
    if(! [doubleMail isKindOfClass:[NSNull class]]){
        doubleMail = [doubleMail stringByReplacingOccurrencesOfString:@" " withString:@""];
        emails = [doubleMail componentsSeparatedByString:@"-"];
    }
    
    if(emails && [emails objectAtIndex:0]){
        self.email1 = [emails objectAtIndex:0];
        if(emails.count > 1 && [emails objectAtIndex:1])
            self.email2 = [emails objectAtIndex:1];
    }
}

@end
