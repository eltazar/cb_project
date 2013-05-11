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
    NSString *formatString = @"http://www.clubmedici.it/nuovo/%@";
    NSDictionary *dict = [json objectAtIndex:0];
    self.ID             = [[dict objectForKey:@"id"] integerValue];
    self.title          = [dict objectForKey:@"title"];
    self.description    = [dict objectForKey:@"description"];
    self.imageUrl       = [NSString stringWithFormat:
                           formatString, [dict objectForKey:@"imageUrl"]];
    self.pdfUrl         = [NSString stringWithFormat:
                           formatString, [dict objectForKey:@"pdfUrl"]];
    self.phone          = [dict objectForKey:@"phone"];
    self.email          = [dict objectForKey:@"email"];
    self.expiryDate     = [dict objectForKey:@"expiryDate"];
    self.inItaly        = [[dict objectForKey:@"inItaly"] boolValue];
}

@end
