//
//  AreaAssicurativa.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 25/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaAssicurativa.h"
#import "WMTableViewDataSource.h"

@implementation AreaAssicurativa

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"AREA ASSICURATIVA ALLOCATO");
        // dati dummy
        self.titolo = @"Viaggi e Turismo";
        self.descrizione = @"Il Club Medici Service mette a disposizione un'attenta e qualificata consulenza assicurativa. I nostri esperti del settore vi guideranno nella scelta della polizza più attinente alle vostre necessità.\n\nPer la professione: RC professionale e tutela legale, infortuni, cassa di assistenza sanitaria, fondo pensione aperto, studio professionale.\n\nPer la vita privata: abitazione, RC auto, responsabilità civile del capofamiglia.\n\n\nClub Medici Service Srl\nVia G.Marchi,10 – 00161 Roma\nP.IVA 08227321000\nIscrizione R.U.I. E000048942\nCCIAA n. REA 1081812\nAttività svolta esclusivamente quale collaboratore di altri intermediari di riferimento (Agenti, Broker)";
        self.img = @"xxxxx";
        self.tel = @"06/86 07 891";
        self.email = @"assicurati@clubmedici.it";
        
        self.pdfList = [[NSMutableArray alloc] initWithObjects:
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
                                                     @"url/ciao.it",     @"URL", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     @"pdf",             @"DATA_KEY",
                                                     @"Titolo 4",        @"LABEL",
                                                     @"url/ciao.it",     @"URL", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     @"pdf",             @"DATA_KEY",
                                                     @"Titolo 5",        @"LABEL",
                                                     @"url/ciao.it",     @"URL", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     @"pdf",             @"DATA_KEY",
                                                     @"Titolo 6",        @"LABEL",
                                                     @"url/ciao.it",     @"URL", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     @"pdf",             @"DATA_KEY",
                                                     @"Titolo 7",        @"LABEL",
                                                     @"url/ciao.it",     @"URL", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     @"pdf",             @"DATA_KEY",
                                                     @"Titolo 8",        @"LABEL",
                                                     @"url/ciao.it",     @"URL", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     @"pdf",             @"DATA_KEY",
                                                     @"Titolo 9",        @"LABEL",
                                                     @"url/ciao.it",     @"URL", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     @"pdf",             @"DATA_KEY",
                                                     @"Titolo 10",       @"LABEL",
                                                     @"url/ciao.it",     @"URL", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     @"pdf",             @"DATA_KEY",
                                                     @"Titolo 11",       @"LABEL",
                                                     @"url/ciao.it",     @"URL", nil],
                        [[NSDictionary alloc] initWithObjectsAndKeys:
                                                     @"pdf",             @"DATA_KEY",
                                                     @"Titolo 12",       @"LABEL",
                                                     @"url/ciao.it",     @"URL", nil], nil];
    }
    return self;
}

- (WMTableViewDataSource *)getDataModel {
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
    if(self.email != nil)
        [informazioniContents addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"email",              @"DATA_KEY",
                                         self.email,            @"LABEL", nil]];
    
    [informazioni setObject:@"Informazioni"         forKey:@"SECTION_NAME"];
    [informazioni setObject:informazioniContents    forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:informazioni];
    
    // Dati per la sezione 1
    NSMutableDictionary *documenti = [[NSMutableDictionary alloc] initWithCapacity:2];
    [documenti setObject:@"Servizi Turistici ai Soci" forKey:@"SECTION_NAME"];
    [documenti setObject:self.pdfList forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:documenti];
    
    
    return [[WMTableViewDataSource alloc] initWithArray: dataModel];
}

@end