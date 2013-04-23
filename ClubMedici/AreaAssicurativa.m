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
        //NSLog(@"AREA ASSICURATIVA ALLOCATO");
        // dati dummy
       /* self.titolo = @"Area Assicurativa";
        self.descrizione = @"Il Club Medici Service mette a disposizione un'attenta e qualificata consulenza assicurativa. I nostri esperti del settore vi guideranno nella scelta della polizza più attinente alle vostre necessità.\n\nPer la professione: RC professionale e tutela legale, infortuni, cassa di assistenza sanitaria, fondo pensione aperto, studio professionale.\n\nPer la vita privata: abitazione, RC auto, responsabilità civile del capofamiglia.\n\n\nClub Medici Service Srl\nVia G.Marchi,10 – 00161 Roma\nP.IVA 08227321000\nIscrizione R.U.I. E000048942\nCCIAA n. REA 1081812\nAttività svolta esclusivamente quale collaboratore di altri intermediari di riferimento (Agenti, Broker)";
        self.img = @"xxxxx";
        self.tel = @"06/86 07 891";
        self.email1 = @"assicurati@clubmedici.it";
        
        self.itemList = [[NSMutableArray alloc] initWithObjects:
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
        */
    }
    return self;
}


@end