//
//  AreaTurismoSection.h
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessLogicBase.h"

@interface AreaTurismoSection : BusinessLogicBase { }

@property (nonatomic, assign) NSInteger sectionId;

- (WMTableViewDataSource *)getDataModelItaly;
- (WMTableViewDataSource *)getDataModelAbroad;

@end
