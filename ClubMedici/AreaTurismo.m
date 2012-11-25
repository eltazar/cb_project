//
//  AreaTurismo.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 24/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaTurismo.h"
#import "WMTableViewDataModel.h"


@implementation AreaTurismo


- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"AREA TURISMO ALLOCATO");
        // dati dummy
        self.titolo = @"Viaggi e Turismo";
        self.descrizione = @"Club Medici Turismo vi propone destinazioni in tutto il mondo e vi offre la qualità di proposte dei principali tour operator, i migliori alberghi e villaggi turistici.\nLo staff di Club Medici Turismo è a vostra completa disposizione per offrirvi una assistenza continua e un filo diretto per proporvi tutti i vantaggi delle nostre proposte. La professionalità delle nostre operatrici vi accompagnerà in ogni passo, dalla scelta del viaggio fino al soggiorno nella destinazione dei vostri sogni, scegliendo la formula più adatta ai vostri desideri.\nCon Club Medici Turismo i soci possono prenotare a prezzi speciali soluzioni per tutte le esigenze di viaggio: viaggi individuali e di gruppo, soggiorni mare, settimane bianche, weekend culturali e benessere.";
        self.img = @"xxxxx";
        self.tel = @"06/86 07 891";
        self.email = @"viaggia@clubmedici.it";
        
        self.itemList = [[NSArray alloc] initWithObjects:
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"categoriaviaggi",     @"DATA_KEY",
                                      @"xyz",                 @"SOME_KEY",
                                      @"Mare",                @"LABEL",
                                      @"mare.png",            @"IMG", nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"categoriaviaggi",     @"DATA_KEY",
                                      @"xyz",                 @"SOME_KEY",
                                      @"Montagna",            @"LABEL",
                                      @"mare.png",            @"IMG", nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"categoriaviaggi",     @"DATA_KEY",
                                      @"xyz",                 @"SOME_KEY",
                                      @"Gruppi ClubMedici",   @"LABEL",
                                      @"mare.png",            @"IMG", nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"categoriaviaggi",     @"DATA_KEY",
                                      @"xyz",                 @"SOME_KEY",
                                      @"Crociere",            @"LABEL",
                                      @"mare.png",            @"IMG", nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"categoriaviaggi",     @"DATA_KEY",
                                      @"xyz",                 @"SOME_KEY",
                                      @"Last Minute",         @"LABEL",
                                      @"mare.png",            @"IMG", nil], nil];
    }
    return self;
}

- (WMTableViewDataModel *)getDataModel {
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
    NSMutableDictionary *categorie = [[NSMutableDictionary alloc] initWithCapacity:2];
    [categorie setObject:@"Servizi Turistici ai Soci" forKey:@"SECTION_NAME"];
    [categorie setObject:self.itemList forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:categorie];
    

    return [[WMTableViewDataModel alloc] initWithArray: dataModel];
}

@end
