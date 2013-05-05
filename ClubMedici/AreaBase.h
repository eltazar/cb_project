//
//  AreaBase.h
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMHTTPAccess.h"

@class WMTableViewDataSource;
@protocol AreaDelegate;


@interface AreaBase : NSObject<WMHTTPAccessDelegate>

@property(nonatomic, assign) int areaID;
@property(nonatomic, strong) id<AreaDelegate> delegate;
@property(nonatomic, strong) NSString *titolo;
@property(nonatomic, strong) NSString *descrizione;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *tel;
@property(nonatomic, strong) NSString *email1;
@property(nonatomic, strong) NSString *email2;
@property(nonatomic, strong) NSMutableArray  *itemList;

+ (NSString *)getAreaType:(NSInteger)areaID;

- (id)initWithJson:(NSArray*)json;
- (WMTableViewDataSource *)getDataModel;
- (NSMutableArray *)_getDataModelArray;
- (void)fetchData;

@end



@protocol AreaDelegate <NSObject>
@optional
- (void)didReceiveAreaData;
@required
- (void)didReceiveAreaDataError:(NSString *)error;
@end



