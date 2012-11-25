//
//  RichiestaIscrizioneController.m
//  ClubMedici
//
//  Created by mario greco on 23/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "RichiestaIscrizioneController.h"
#import "WMTableViewDataSource.h"

@interface RichiestaIscrizioneController ()

@end

@implementation RichiestaIscrizioneController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [super initWithNibName:@"FormViewController" bundle:nil];
    if(self){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.title = @"Richiesta iscrizione";
    
    _dataModel = [[WMTableViewDataSource alloc] initWithPList:@"RichiestaIscrizione"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
