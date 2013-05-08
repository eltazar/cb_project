//
//  AreaTurismoItem.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "AreaTurismoItem.h"

@implementation AreaTurismoItem

- (void)_buildFromJson:(NSArray *)json {
    NSDictionary *dict = [json objectAtIndex:0];
    self.ID             = [dict objectForKey:@"id"];
    self.title          = [dict objectForKey:@"title"];
    self.description    = [dict objectForKey:@"description"];
    self.imageUrl       = [dict objectForKey:@"imageUrl"];
    self.pdfUrl         = [dict objectForKey:@"pdfUrl"];
    self.phone          = [dict objectForKey:@"phone"];
    self.email          = [dict objectForKey:@"email"];
    self.expiryDate     = [dict objectForKey:@"expiryDate"];
}

@end
