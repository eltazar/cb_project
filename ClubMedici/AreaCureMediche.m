//
//  AreaCureMediche.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaCureMediche.h"
#import "WMTableViewDataSource.h"

@implementation AreaCureMediche

-(id)init{
    
    self = [super init];
    if (self) {
        // dati dummy
        /*self.titolo = @"Cure mediche rateali";
        self.descrizione = @"Il finanziamento per cure sanitarie a rimborso rateale è un credito personale che anticipa le parcelle ai medici permettendo ai pazienti di rateizzare i costi di cure odontoiatriche, di medicina estetica, di chirurgia generale a condizioni agevolate";
        
        self.img =@"xxxxx";
        self.tel = @"06/8607891";
        self.email1 = @"prestiti@clubmedici.it";
        
        //SUPPONENDO CHE I LINK PDF LI STRUTTURIAMO COSì DOPO LA QUERY
        //array di dati per la sezione 1
        self.itemList = [[NSArray alloc] initWithObjects:
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"pdf",          @"DATA_KEY",
                                   @"Titolo 1",     @"LABEL",
                                   @"url/ciao.it",  @"URL", nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"pdf",          @"DATA_KEY",
                                   @"Titolo 2",     @"LABEL",
                                   @"url/ciao.it",  @"URL", nil],
                         [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"pdf",          @"DATA_KEY",
                                   @"Titolo 3",     @"LABEL",
                                   @"url/ciao.it",  @"URL", nil], nil];
         */
        
        // [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link1",@"Titolo1", nil]];
        // [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link2",@"Titolo2", nil]];
        // [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link3",@"Titolo3", nil]];
    }
    return self;
}

- (NSMutableArray *)_getDataModelArray {
    NSMutableArray *dataModel = [super _getDataModelArray];
    
    // Dati per la sezione 2
    NSMutableDictionary *simulatoreRate    = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSMutableArray *simulatoreRateContents = [[NSMutableArray alloc] initWithCapacity:1];
        
    [simulatoreRateContents insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"calcolatore",           @"DATA_KEY",
                                 @"Calcola rata",   @"LABEL", nil] atIndex: 0];
    
    [simulatoreRate setObject:@"Simulatore Rate"        forKey:@"SECTION_NAME"];
    [simulatoreRate setObject:simulatoreRateContents    forKey:@"SECTION_CONTENTS"];
    [dataModel addObject:simulatoreRate];
    
    return dataModel;
}

@end
