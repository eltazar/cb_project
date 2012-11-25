//
//  AreaBase.h
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMTableViewDataSource;

@interface AreaBase : NSObject

@property(nonatomic, strong) NSString *titolo;
@property(nonatomic, strong) NSString *descrizione;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *tel;
@property(nonatomic, strong) NSString *email1;
@property(nonatomic, strong) NSString *email2;
@property(nonatomic, strong) NSArray  *itemList;

- (WMTableViewDataSource *)getDataModel;

- (NSMutableArray *)_getDataModelArray;

@end
