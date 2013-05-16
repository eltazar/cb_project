//
//  Utilis.m
//  ClubMedici
//
//  Created by mario greco on 05/02/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "Utilities.h"
#import "AreaBase.h"
#import "Reachability.h"
#import "Flurry.h"

@implementation Utilities

+(BOOL)networkReachable {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    BOOL result = NO;
    
    if(internetStatus == ReachableViaWWAN){
        //NSLog(@"3g");
        result =  YES;
        
    }
    else if(internetStatus == ReachableViaWiFi){
        //NSLog(@"Wifi");
        result = YES;
        
    }
    else if(internetStatus == NotReachable){
        result = NO;
    }
    
    return  result;
}

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
    
    //nslog(@"_PHONE = %@",_phone);
    
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
    
    //nslog(@"STRIPPED STRING = %@",strippedString);
    
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


+ (void)saveCustomObject:(/*AreaBase **/id)obj key:(NSString*)key {
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:key];
    [defaults synchronize];
}

+ (/*AreaBase **/id)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:key];
    /*AreaBase *obj = (AreaBase *)*/ return [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    //return obj;
}

+ (void)callNumber:(NSString*)number {
    //fa partire una chiamata
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
        NSString *phoneNumber = [NSString stringWithFormat:@"%@%@", @"tel://", number];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber
                                                    ]];
    }
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Spiacenti" message:@"Questa funzione non è disponibile su questo dispositivo" delegate:nil cancelButtonTitle:@"Chiudi" otherButtonTitles:nil];
        [alert show];
    }
}

+ (void)sendEmail:(NSString*)address controller:(UIViewController*)controller delegate:(id<MFMailComposeViewControllerDelegate>)delegate {
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = delegate;
    
    if([MFMailComposeViewController canSendMail]){
        [mail setToRecipients:[NSArray arrayWithObjects:address, nil]];
        [mail setSubject:@"Informazioni"];
        [mail setMessageBody:@"" isHTML:NO];
        [controller presentModalViewController:mail animated:YES];
    }
}

+ (void)sendEmail:(NSString *)address object:(NSString*)object content:(NSString*)content html:(BOOL)html controller:(UIViewController *)controller delegate:(id<MFMailComposeViewControllerDelegate>)delegate {
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = delegate;
    
    if([MFMailComposeViewController canSendMail]){
        [mail setToRecipients:[NSArray arrayWithObjects:address, nil]];
        [mail setSubject:object];
        [mail setMessageBody:content isHTML:html];
        [controller presentModalViewController:mail animated:YES];
    }
}

+(void)logEvent:(NSString*)key arguments:(NSDictionary*)arguments{
    //nslog(@"CIAOOO");
    if(arguments == nil)
       [Flurry logEvent:key];
    else [Flurry logEvent:key withParameters:arguments];
}
@end
