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
    self.ID             = [[dict objectForKey:@"id"] integerValue];
    self.title          = [dict objectForKey:@"title"];
    if([[AreaTurismoItem stripWhiteSpaces:[dict objectForKey:@"description"]] isKindOfClass:[NSNull class]] ||
       [[AreaTurismoItem stripWhiteSpaces:[dict objectForKey:@"description"]] isEqualToString:@""]){
        self.description = @"Scopri di più...";
    }
    else self.description    = [AreaTurismoItem stripWhiteSpaces:[dict objectForKey:@"description"]];
    self.imageUrl       = [AreaTurismoItem buildUrl:[dict objectForKey:@"imageUrl"]];
    self.pdfUrl         = [AreaTurismoItem buildUrl:[dict objectForKey:@"pdfUrl"]];
    self.phone          = [dict objectForKey:@"phone"];
    self.email          = [dict objectForKey:@"email"];
    self.expiryDate     = [dict objectForKey:@"expiryDate"];
    self.inItaly        = [[dict objectForKey:@"inItaly"] boolValue];
}

+ (NSString *)buildUrl:(NSString *)url {
    NSString *formatString = @"http://www.clubmedici.it/nuovo/%@";
    NSMutableString *newUrl = [[self stripWhiteSpaces:url] mutableCopy];
    [newUrl replaceOccurrencesOfString:@" "
                            withString:@"%20"
                               options:nil
                                 range:NSMakeRange(0, [newUrl length])];
    return [NSString stringWithFormat:formatString, newUrl];
}

+ (NSString *)stripWhiteSpaces:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
