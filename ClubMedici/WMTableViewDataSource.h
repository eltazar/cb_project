//
//  WMTableViewDataModel.h
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 24/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, weak)   NSObject *cellFactory;
@property (nonatomic, assign) BOOL showSectionHeaders;

- (id)initWithPList:(NSString *)file;
- (id)initWithArray:(NSArray *)array;

- (id)valueForKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath;

@end
