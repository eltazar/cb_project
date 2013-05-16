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
    Class class = NSClassFromString(IDIOM_SPECIFIC_STRING(NSStringFromClass(self.class)));
    id viewController = [[class alloc] init];
    if (!viewController) {
        //nslog(@"uh-oh");
        viewController = [[self alloc] init];
    }
    return viewController;
}


@end

BOOL iPhoneIdiom() {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

BOOL iPadIdiom() {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}
