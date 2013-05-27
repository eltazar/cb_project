//
//  Utilis.h
//  ClubMedici
//
//  Created by mario greco on 05/02/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@class AreaBase;

@interface Utilities : NSObject <MFMailComposeViewControllerDelegate>

+ (BOOL)networkReachable;
+ (BOOL)checkEmail:(NSString*)email;
//+ (BOOL)checkPhone:(NSString *)_phone;
+ (BOOL)isNumeric:(NSString*)inputString;
+ (void)saveCustomObject:(id)obj key:(NSString*)key;
+ (id)loadCustomObjectWithKey:(NSString *)key;
+ (void)sendEmail:(NSString*)address controller:(UIViewController*)controller delegate:(id<MFMailComposeViewControllerDelegate>)delegate;
+ (void)callNumber:(NSString*)number;
+ (void)sendEmail:(NSString *)address object:(NSString*)object content:(NSString*)content html:(BOOL)html controller:(UIViewController *)controller delegate:(id<MFMailComposeViewControllerDelegate>)delegate;
+(void)logEvent:(NSString*)key arguments:(NSDictionary*)arguments;

@end
