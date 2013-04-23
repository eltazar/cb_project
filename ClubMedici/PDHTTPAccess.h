//
//  PDHTTPAccess.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMHTTPAccess.h"


@interface PDHTTPAccess : NSObject

+ (void)getAreaContents:(int)areaId delegate:(id<WMHTTPAccessDelegate>)delegate;
+ (void) getDocumentContents:(int)pagId delegate:(id<WMHTTPAccessDelegate>)delegate;
@end
