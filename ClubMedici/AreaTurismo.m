//
//  AreaTurismo.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 24/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "AreaTurismo.h"
#import "WMTableViewDataSource.h"


@implementation AreaTurismo


- (id)init {
    self = [super init];
    if (self) {
        self.itemList = [[NSMutableArray alloc] initWithContentsOfFile:@"AreaTurismoItemList"];
        if (!self.itemList) {
            self.itemList = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AreaTurismoItemList" ofType:@"plist"]];
        }
        /*self.itemList = [[NSArray alloc] initWithObjects:
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
                                      @"mare.png",            @"IMG", nil], nil];*/
    }
        
    return self;
}


- (void)_buildFromJson:(NSArray *)json {
    [super _buildFromJson:json];
    self.itemList = [[NSMutableArray alloc] initWithContentsOfFile:@"AreaTurismoItemList"];
    if (!self.itemList) {
        self.itemList = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AreaTurismoItemList" ofType:@"plist"]];
    }
}




@end

