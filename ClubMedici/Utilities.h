//
//  Utilis.h
//  ClubMedici
//
//  Created by mario greco on 05/02/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AreaBase;

@interface Utilities : NSObject

+(BOOL) checkEmail:(NSString*)email;
+(BOOL) checkPhone:(NSString *)_phone;
+(BOOL) isNumeric:(NSString*)inputString;
+ (void)saveCustomObject:(AreaBase *)obj key:(NSString*)key;
+ (AreaBase *)loadCustomObjectWithKey:(NSString *)key;
@end
