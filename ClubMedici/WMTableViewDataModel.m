//
//  WMTableViewDataModel.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 24/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "WMTableViewDataModel.h"

@interface WMTableViewDataModel() {
    NSArray *_data;
}
@end

@implementation WMTableViewDataModel

NSString *const SECTION_NAME = @"SECTION_NAME";
NSString *const SECTION_CONTENTS = @"SECTION_CONTENTS";

- (id) init {
    self = [super init];
    if (self) {
        _data = nil;
    }
    return self;
}

- (id) initWithPList:(NSString *)file {
    self = [super init];
    if (self) {
        _data = [[NSArray alloc] initWithContentsOfFile:file];
        NSLog(@"SideMenu data is: %@", _data);
        if (!_data) {
            _data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:@"plist"]];
        }
        NSLog(@"SideMenu data is: %@", _data);
    }
    return self;
}

- (id) initWithArray:(NSArray *)array {
    self = [super init];
    if (self) {
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
    return [[_data objectAtIndex:section] objectForKey:SECTION_NAME];
}

- (NSString *)titleForFooterInSection:(NSInteger)section {
    return @"";
}

- (NSString *)valueForKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath {
    NSArray *section = [[_data objectAtIndex:indexPath.section]
                             objectForKey:SECTION_CONTENTS];
    NSLog(@"SideMenu section is: %@", section);
    return  [[section objectAtIndex:indexPath.row] objectForKey:key];
}


@end
