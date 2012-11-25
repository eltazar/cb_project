//
//  WMTableViewDataModel.h
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 24/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMTableViewDataModel : NSObject

- (id) initWithPList:(NSString *)file;
- (id) initWithArray:(NSArray *)array;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSString *)titleForHeaderInSection:(NSInteger)section;
- (NSString *)titleForFooterInSection:(NSInteger)section;
- (NSString *)valueForKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath;

@end
