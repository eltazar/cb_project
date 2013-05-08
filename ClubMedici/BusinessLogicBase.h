//
//  BusinessLogicBase.h
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMHTTPAccess.h"

@class WMTableViewDataSource;
@protocol BusinessLogicDelegate;



@interface BusinessLogicBase : NSObject<WMHTTPAccessDelegate> {
    
}

@property(nonatomic, strong) id<BusinessLogicDelegate> delegate;


- (id)initWithJson:(NSArray*)json;
- (WMTableViewDataSource *)getDataModel;
- (void)fetchData;


- (void)_buildFromJson:(NSArray *)json;


@end




@protocol BusinessLogicDelegate <NSObject>
@optional
- (void)didReceiveBusinessLogicData;
@required
- (void)didReceiveBusinessLogicDataError:(NSString *)error;
@end
