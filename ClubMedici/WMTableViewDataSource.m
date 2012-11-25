//
//  WMTableViewDataModel.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 24/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "WMTableViewDataSource.h"

@interface WMTableViewDataSource() {
    NSArray *_data;
}
@end

@implementation WMTableViewDataSource

NSString *const SECTION_NAME = @"SECTION_NAME";
NSString *const SECTION_CONTENTS = @"SECTION_CONTENTS";

- (id) init {
    self = [super init];
    if (self) {
        self.showSectionHeaders = YES;
        _data = nil;
    }
    return self;
}

- (id) initWithPList:(NSString *)file {
    self = [super init];
    if (self) {
        self.showSectionHeaders = YES;
        _data = [[NSArray alloc] initWithContentsOfFile:file];
        if (!_data) {
            _data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:@"plist"]];
        }
    }
    return self;
}

- (id) initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
        self.showSectionHeaders = YES;
        _data = array;
    }
    return self;
}


- (NSInteger)numberOfSections {
    return [_data count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [[[_data objectAtIndex:section] objectForKey:SECTION_CONTENTS] count];
}


- (NSString *)titleForHeaderInSection:(NSInteger)section {
    if (self.showSectionHeaders) {
        return [[_data objectAtIndex:section] objectForKey:SECTION_NAME];
    }
    else
        return nil;
}

- (NSString *)titleForFooterInSection:(NSInteger)section {
    return @"";
}

- (NSString *)valueForKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath {
    NSArray *section = [[_data objectAtIndex:indexPath.section]
                             objectForKey:SECTION_CONTENTS];
    return  [[section objectAtIndex:indexPath.row] objectForKey:key];
}


@end
