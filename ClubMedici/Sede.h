//
//  Sede.h
//  ClubMedici
//
//  Created by mario greco on 02/02/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Sede : NSObject <MKAnnotation>{
    NSString *name;
    NSString *city;
    NSString *address;
    CLLocationCoordinate2D coordinate;
}

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *city;
@property(nonatomic) CLLocationCoordinate2D coordinate;


-(id) initWithCoordinate:(CLLocationCoordinate2D)coord;

@end