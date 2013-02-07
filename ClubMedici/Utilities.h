//
//  Utilis.h
//  ClubMedici
//
//  Created by mario greco on 05/02/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(BOOL) checkEmail:(NSString*)email;
+(BOOL) checkPhone:(NSString *)_phone;
+(BOOL) isNumeric:(NSString*)inputString;
@end
