//
//  AreaTurismoItem.h
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "BusinessLogicBase.h"

@interface AreaTurismoItem : BusinessLogicBase

@property(nonatomic, assign) NSInteger ID;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) NSString *pdfUrl;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSDate   *expiryDate;

@end
