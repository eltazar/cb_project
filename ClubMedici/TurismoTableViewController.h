//
//  TurismoTableViewController.h
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 08/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaTurismoSection.h"
#import "BusinessLogicBase.h"
#import "WMTableViewDataSource.h"
#import "PullToRefreshView.h"

@interface TurismoTableViewController : UITableViewController<BusinessLogicDelegate, PullToRefreshViewDelegate> {
    @protected
        WMTableViewDataSource *_dataModelItaly;
        WMTableViewDataSource *_dataModelAbroad;
}

@property(nonatomic, strong) AreaTurismoSection *areaTurismoSection;


@end
