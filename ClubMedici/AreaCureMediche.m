//
//  AreaCureMediche.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaCureMediche.h"

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
        
//        [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link1",@"Titolo1", nil]];
//        [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link2",@"Titolo2", nil]];
//        [self.pdfList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"link3",@"Titolo3", nil]];
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
     */
    
    
    //data model totale
    NSMutableDictionary *dataModel = [[NSMutableDictionary alloc] init];
    
    //array di dati  per le varie sezioni
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:3];
    
    //array di titoli sezione
    [dataModel setObject:[NSArray arrayWithObjects:@"Informazioni",@"Documenti",@"Simulatore rate", nil] forKey:@"sections"];
    
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
    if(self.email != nil){
        [info insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                            @"email",    @"DataKey",
                            self.email,   @"label",
                            nil] atIndex: 2];
    }
    
    
    [data insertObject:info atIndex:0];
    
    //array di dati per la sezione 1
    [data insertObject:self.pdfList atIndex:1];
    
    
    //array di dati per la sezione 2
    NSMutableArray *preventivo = [[NSMutableArray alloc] initWithCapacity:3];
    [preventivo addObject:@"Calcola rata"];
    
    
    NSMutableArray *tipoRichieste = [[NSMutableArray alloc] init];
    
    [tipoRichieste insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"cure",    @"DataKey",
                                 @"Calcola rata",   @"label",
                                 nil] atIndex: 0];

    
    [data insertObject:tipoRichieste atIndex:2];
    
    [dataModel setObject:data forKey:@"data"];
    
    NSLog(@"DATA MODEL = %@",dataModel);
    
    return dataModel;

}

@end
