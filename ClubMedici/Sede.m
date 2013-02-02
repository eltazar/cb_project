//
//  Sede.m
//  ClubMedici
//
//  Created by mario greco on 02/02/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "Sede.h"

@implementation Sede
@synthesize city,address, coordinate, name, title, subtitle;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    
    return self;
}


- (NSString *)title {
    return name;
    
}

- (NSString *)subtitle {
    
    return city;
}
@end
