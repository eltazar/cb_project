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
    NSMutableArray *_items;
}
@end



@implementation AreaTurismoSection

- (id)init {
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}



# pragma mark - Public Methods



- (WMTableViewDataSource *)getDataModel {
    NSMutableArray *sectionContentsArray = [NSMutableArray arrayWithCapacity:_items.count];
    for (id item in _items) {
        [sectionContentsArray addObject:[NSDictionary dictionaryWithObject:item forKey:@"ITEM"]];
    }
    NSArray *dataModelArray = [NSArray arrayWithObject:
                               [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"Lista Offerte",     @"SECTION_NAME",
                                    sectionContentsArray, @"SECTION_CONTENTS", nil]];
    return [[WMTableViewDataSource alloc] initWithArray:dataModelArray];
}


- (void)fetchData {
    [PDHTTPAccess getAreaTurismoDataForSectionId:self.sectionId inItaly:YES delegate:self];
}



#pragma mark - WMHTTPAccessDelegate



- (void)didReceiveJSON:(NSArray *)jsonArray {
    NSArray *tempArray;
    for (NSDictionary *item in jsonArray) {
        tempArray = [NSArray arrayWithObject:item];
        [_items addObject:[[AreaTurismoItem alloc] initWithJson:tempArray]];
    }
    [self.delegate didReceiveBusinessLogicData];
}

@end
