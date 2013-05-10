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
}
@end



@implementation AreaTurismoSection

- (id)init {
    self = [super init];
    if (self) {
        _itemsItaly  = [[NSMutableArray alloc] init];
        _itemsAbroad = [[NSMutableArray alloc] init];
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
        tempArray = [NSArray arrayWithObject:item];
        AreaTurismoItem *areaTurismoItem = [[AreaTurismoItem alloc] initWithJson:tempArray];
        if (areaTurismoItem.inItaly)
            [_itemsItaly  addObject:[NSDictionary dictionaryWithObject:areaTurismoItem
                                                                forKey:@"ITEM"]];
        else
            [_itemsAbroad addObject:[NSDictionary dictionaryWithObject:areaTurismoItem
                                                                forKey:@"ITEM"]];
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
