//
//  ViewController+InterfaceIdiom.h
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 23/11/12.
//

#define IDIOM_SPECIFIC_STRING(str) [NSString stringWithFormat:@"%@%@", (str), (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? @"_iPhone" : @"_iPad"]

#define ORIENTATION_SPECIFIC_STRING(str) [NSString stringWithFormat:@"%@%@", (str), UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)? @"_Land" : @"_Port"]

@interface UIViewController (InterfaceIdiom)

+ (id) idiomAllocInit;

@end

BOOL iPhoneIdiom();
BOOL iPadIdiom();
