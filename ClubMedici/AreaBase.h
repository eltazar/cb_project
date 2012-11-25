//
//  AreaBase.h
//  ClubMedici
//
//  Created by mario greco on 20/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WMTableViewDataSource;

@interface AreaBase : NSObject

@property(nonatomic, strong) NSString *titolo;
@property(nonatomic, strong) NSString *descrizione;
@property(nonatomic, strong) NSString *img;
@property(nonatomic, strong) NSString *tel;
//la sezione viaggi non ha pdf nella view generale.. nella classe specializzata possiamo ignorare sta ivar
@property(nonatomic, strong) NSMutableArray *pdfList;

- (WMTableViewDataSource *)getDataModel;
@end
