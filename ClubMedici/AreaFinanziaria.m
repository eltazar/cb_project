//
//  AreaFinanziaria.m
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaFinanziaria.h"

@implementation AreaFinanziaria
@synthesize emailMutuo,emailPrestito;

-(id)init{
    
    self = [super init];
    if (self) {
        NSLog(@"AREA FINANZ ALLOCATO");
        // dati dummy
        self.titolo = @"Area finanziaria";
        self.descrizione = @"L’area finanziaria di Club Medici è costituita da un team di specialisti informati e disponibili, pronti a consigliare l’offerta più adatta alle vostre necessità e a seguirvi, passo dopo passo, nel corso del processo di approvazione della vostra richiesta.\n L’area finanziaria di Club Medici offre servizio di consulenza per: mutui, prestiti personali e cessione del quinto per medici ospedalieri, di base, pediatri, sumaisti e pensionati. ";
        
        self.img =@"xxxxx";
        self.tel = @"06/8607891";
        self.emailPrestito = @"prestiti@clubmedici.it";
        self.emailMutuo = @"mutui@clubmedici.it";
        
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
     */
    
    
    //data model totale
    NSMutableDictionary *dataModel = [[NSMutableDictionary alloc] init];
    
    //array di dati  per le varie sezioni
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:2];
    
    //array di titoli sezione
    [dataModel setObject:[NSArray arrayWithObjects:@"Informazioni",@"Documenti", nil] forKey:@"sections"];
    
    //array di dati per la sezione 0
    NSMutableArray *info = [[NSMutableArray alloc] init];
   
    if(self.descrizione != nil)
        [info addObject:self.descrizione];
    if(self.tel != nil)
       [info addObject:self.tel];
    if(self.emailMutuo != nil)
       [info addObject:self.emailMutuo];
    if(self.emailPrestito != nil)
        [info addObject:self.emailPrestito];
    
    [data insertObject:info atIndex:0];
    
        
    [data insertObject:self.pdfList atIndex:1];
    
    [dataModel setObject:data forKey:@"data"];
    
    //NSLog(@"DATA MODEL = %@",dataModel);
    
    return dataModel;
}

@end
