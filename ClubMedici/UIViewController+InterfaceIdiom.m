//
//  ViewController+InterfaceIdiom.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 23/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "UIViewController+InterfaceIdiom.h"

@implementation UIViewController (InterfaceIdiom)

+ (id)idiomAllocInit {
    NSString *idiom;
    idiom = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)? @"_iPhone" : @"_iPad";
    Class class = NSClassFromString([NSString stringWithFormat:@"%@%@",
                                    NSStringFromClass(self.class), idiom]);
    id viewController = [[class alloc] init];
    if (!viewController)
        NSLog(@"uh-oh");
    return viewController;
}

@end
