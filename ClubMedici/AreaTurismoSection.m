//
//  AreaTurismoSection.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "AreaTurismoSection.h"
#import "AreaTurismoItem.h"
#import "WMTableViewDataSource.h"
#import "PDHTTPAccess.h"


@interface AreaTurismoSection () {
    NSMutableArray *_itemsItaly;
    NSMutableArray *_itemsAbroad;
    NSMutableSet *_itemsItalyIdSet;
    NSMutableSet *_itemsAbroadIdSet;
}
@end



@implementation AreaTurismoSection

- (id)init {
    self = [super init];
    if (self) {
        _itemsItaly  = [[NSMutableArray alloc] init];
        _itemsAbroad = [[NSMutableArray alloc] init];
        _itemsItalyIdSet  = [[NSMutableSet alloc] init];
        _itemsAbroadIdSet = [[NSMutableSet alloc] init];
     }
    return self;
}



# pragma mark - Public Methods



- (WMTableViewDataSource *)getDataModel {
    return [self _getDataModelFromItems:_itemsItaly];
}

- (WMTableViewDataSource *)getDataModelItaly {
    return [self _getDataModelFromItems:_itemsItaly];
}


- (WMTableViewDataSource *)getDataModelAbroad {
    return [self _getDataModelFromItems:_itemsAbroad];
}


- (void)fetchData {
    [PDHTTPAccess getAreaTurismoDataForSectionId:self.sectionId inItaly:YES delegate:self];
    [PDHTTPAccess getAreaTurismoDataForSectionId:self.sectionId inItaly:NO  delegate:self];
}



#pragma mark - WMHTTPAccessDelegate



- (void)didReceiveJSON:(NSArray *)jsonArray {
    NSArray *tempArray;
    for (NSDictionary *item in jsonArray) {
        // Costruiamo un array di un solo elemento, temporaneo, perché initWithJson: di
        // BusinessLogicBase accetta come parametro un NSArray
        tempArray = [NSArray arrayWithObject:item];
        AreaTurismoItem *areaTurismoItem = [[AreaTurismoItem alloc] initWithJson:tempArray];
        
        
        // Controlla se l'item è già presente
        NSMutableSet *workingSet = (areaTurismoItem.inItaly)?_itemsItalyIdSet:_itemsAbroadIdSet;
        NSSet *filteredSet = [workingSet objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            if ([obj integerValue] == areaTurismoItem.ID) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        
        NSMutableArray *workingDataModel = (areaTurismoItem.inItaly)?_itemsItaly:_itemsAbroad;
        NSNumber *itemID = [NSNumber numberWithInteger:areaTurismoItem.ID];
        if (filteredSet.count == 0) {
            //nslog(@"aggiungo: %d", areaTurismoItem.ID);
            [workingDataModel addObject:[NSDictionary dictionaryWithObject:areaTurismoItem
                                                                    forKey:@"ITEM"]];
            [workingSet addObject:itemID];
        }
    }
    [self.delegate didReceiveBusinessLogicData];
}



#pragma mark - Private Methods



- (WMTableViewDataSource *)_getDataModelFromItems:(NSArray *)items {
    NSArray *dataModelArray = [NSArray arrayWithObject:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Lista Offerte",     @"SECTION_NAME",
                                items, @"SECTION_CONTENTS", nil]];
    //NSLog(@"Same object? %@", ([[dataModelArray objectAtIndex:0] objectForKey:@"SECTION_CONTENTS"] ==  items)?@"YES":@"NO");
    return [[WMTableViewDataSource alloc] initWithArray:dataModelArray];
}



@end
