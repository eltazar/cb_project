//
//  AreaCureMediche.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaCureMediche.h"
#import "WMTableViewDataModel.h"

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
        
        [self.pdfList insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"pdf",          @"DATA_KEY",
                                   @"Titolo 1",     @"LABEL",
                                   @"url/ciao.it",  @"URL",
                                   nil] atIndex: 0];
        [self.pdfList insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"pdf",          @"DATA_KEY",
                                   @"Titolo 2",     @"LABEL",
                                   @"url/ciao.it",  @"URL",
                                   nil] atIndex: 1];
        [self.pdfList insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"pdf",          @"DATA_KEY",
                                   @"Titolo 3",     @"LABEL",
                                   @"url/ciao.it",  @"URL",
                                   nil] atIndex: 2];
        
//        [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link1",@"Titolo1", nil]];
//        [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link2",@"Titolo2", nil]];
//        [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link3",@"Titolo3", nil]];
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
     */
    
    // Data model totale
    NSMutableArray *dataModel = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Dati per la sezione 0
    NSMutableDictionary *informazioni    = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSMutableArray *informazioniContents = [[NSMutableArray alloc] initWithCapacity:3];
    
    if(self.descrizione != nil)
        [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"description",        @"DATA_KEY",
                                         self.descrizione,      @"LABEL", nil]];
    if(self.tel != nil)
        [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"phone",              @"DATA_KEY",
                                         self.tel,              @"LABEL", nil]];
     if(self.email != nil)
         [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"email",              @"DATA_KEY",
                                         self.email,            @"LABEL", nil]];
       
    [informazioni setObject:@"Informazioni"         forKey:@"SECTION_NAME"];
    [informazioni setObject:informazioniContents    forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:informazioni];
    
    // Dati per la sezione 1
    NSMutableDictionary *documenti = [[NSMutableDictionary alloc] initWithCapacity:2];
    [documenti setObject:@"Documenti" forKey:@"SECTION_NAME"];
    [documenti setObject:self.pdfList forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:documenti];
    
    // Dati per la sezione 2
    NSMutableDictionary *simulatoreRate    = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSMutableArray *simulatoreRateContents = [[NSMutableArray alloc] initWithCapacity:1];
        
    [simulatoreRateContents insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"cure",           @"DATA_KEY",
                                 @"Calcola rata",   @"LABEL", nil] atIndex: 0];
    
    [simulatoreRate setObject:@"Simulatore Rate"        forKey:@"SECTION_NAME"];
    [simulatoreRate setObject:simulatoreRateContents    forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:simulatoreRate];
    
    return [[WMTableViewDataModel alloc] initWithArray: dataModel];
}

@end
