//
//  Utilis.m
//  ClubMedici
//
//  Created by mario greco on 05/02/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "Utilities.h"
#import "AreaBase.h"
@implementation Utilities

+(BOOL) checkEmail:(NSString*)email
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL valid = FALSE;
    
    if((email == nil) || [email isEqualToString:@""]){
        valid = FALSE;
    }
    else{
        valid = [emailTest evaluateWithObject:email];
    }

    return valid;
}
/*
+(BOOL) checkPhone:(NSString *)_phone{
    
    BOOL valid = FALSE;    
    
    BOOL isPlus = FALSE;
    
    NSLog(@"_PHONE = %@",_phone);
    
    //se il numero di telefono ha il prefisso internazionale che comincia con +
    if([[_phone substringWithRange:NSMakeRange(0,1)] isEqualToString:@"+"])
        isPlus = TRUE;
    
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:_phone.length+1];
    
    NSScanner *scanner = [NSScanner scannerWithString:_phone];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            
            //reinserisco il + ad inizio stringa
            if(isPlus){
                strippedString = [NSMutableString stringWithFormat:@"%@",@"+"];
                isPlus = FALSE;
            }
            
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    NSLog(@"STRIPPED STRING = %@",strippedString);
    
    return valid;
}
*/
+(BOOL)isNumeric:(NSString*)inputString{
    BOOL isValid = NO;
    NSString *tempString = inputString;
    if([[inputString substringWithRange:NSMakeRange(0,1)] isEqualToString:@"+"]){
        tempString = [inputString substringWithRange:NSMakeRange(1,inputString.length-1)];
    }
    
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:tempString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    
    return isValid;
}


+ (void)saveCustomObject:(AreaBase *)obj key:(NSString*)key {
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:key];
}

+ (AreaBase *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:key];
    AreaBase *obj = (AreaBase *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}
    
@end
