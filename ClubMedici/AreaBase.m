//
//  AreaBase.m
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaBase.h"

@implementation AreaBase

@synthesize titolo, descrizione, img,tel, pdfList;

-(id)init{

    self = [super init];
    if (self) {
        // dati dummy
        
    }
    return self;  
}

-(NSMutableDictionary *) getDataModel{
    return nil;
}

@end
