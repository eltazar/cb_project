//
//  RichiestaIscrizioneControllerViewController.m
//  ClubMedici
//
//  Created by mario greco on 23/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "RichiestaNoleggioController.h"
#import "WMTableViewDataModel.h"

@interface RichiestaNoleggioController ()

@end

@implementation RichiestaNoleggioController
@synthesize kind;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"FormViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init:(NSString *)kindRequest {
    self = [super initWithNibName:@"FormViewController" bundle:nil];
    if(self){
        self.kind = kindRequest;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Annula" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = button;
    
    self.title = @"Richiedi informazioni";
    
    if ([self.kind isEqualToString:@"noleggioAuto"]) {
        _dataModel = [[WMTableViewDataModel alloc]
                      initWithPList:@"RichiestaNoleggioAuto"];
    }
    else { // self.kind == noleggioElettro || self.kind == leasingElettro
        _dataModel = [[WMTableViewDataModel alloc]
                      initWithPList:@"RichiestaNoleggioElettromedicale"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
