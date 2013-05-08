//
//  AreaBase.h
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessLogicBase.h"
#import "WMHTTPAccess.h"


@interface AreaBase : BusinessLogicBase


@property(nonatomic, assign) int areaID;
@property(nonatomic, strong) NSString *titolo;
@property(nonatomic, strong) NSString *descrizione;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *tel;
@property(nonatomic, strong) NSString *email1;
@property(nonatomic, strong) NSString *email2;
@property(nonatomic, strong) NSMutableArray  *itemList;

+ (NSString *)getAreaType:(NSInteger)areaID;

- (id)initWithAreaId:(int)areaID;

- (NSMutableArray *)_getDataModelArray;

@end
