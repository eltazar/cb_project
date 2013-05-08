//
//  BusinessLogicBase.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "BusinessLogicBase.h"
#import "WMTableViewDataSource.h"

@implementation BusinessLogicBase


- (id)initWithJson:(NSArray*)json {
    self = [self init];
    if(self){
        [self _buildFromJson:json];
    }
    return self;
}



#pragma mark - Public Methods



- (WMTableViewDataSource *)getDataModel {
    return [[WMTableViewDataSource alloc] initWithArray: [self _getDataModelArray]];
}


- (void)fetchData { }



#pragma mark - Protected Methods



- (NSMutableArray *)_getDataModelArray { return nil; }
- (void)_buildFromJson:(NSArray *)json { }



#pragma mark - WMHTTPAccessDelegate



- (void)didReceiveError:(NSError *)error {
    NSLog(@"ERRORE = %@",[error description]);
    [self.delegate didReceiveBusinessLogicDataError:@"Errore server"];
}




@end
