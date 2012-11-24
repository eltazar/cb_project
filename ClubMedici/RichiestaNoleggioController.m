//
//  RichiestaIscrizioneControllerViewController.m
//  ClubMedici
//
//  Created by mario greco on 23/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "RichiestaNoleggioController.h"

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
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Annula" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = button;
    
    NSMutableArray *secUserData = [[NSMutableArray alloc] init];
    NSMutableArray *infoData = [[NSMutableArray alloc] init];
    
    self.title = @"Richiedi  informazioni";
    
    
    [infoData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                            @"info",              @"DataKey",
                            @"",                  @"img",
                            nil] atIndex: 0];
    
    
    [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"ragSoc",              @"DataKey",
                               @"Ragione sociale",  @"placeholder",
                               @"",                  @"img",
                               nil] atIndex: 0];
    
    [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"cell",              @"DataKey",
                               @"Cellulare",  @"placeholder",
                               @"",                  @"img",
                               nil] atIndex: 1];
    
    [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"email",              @"DataKey",
                               @"E-mail",  @"placeholder",
                               @"",                  @"img",
                               nil] atIndex: 2];
    
    [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"citta",              @"DataKey",
                               @"Città",  @"placeholder",
                               @"",                  @"img",
                               nil] atIndex: 3];
    
    if ([self.kind isEqualToString:@"noleggioAuto"]) {
        
        [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"iva",              @"DataKey",
                                   @"Partita iva",  @"placeholder",
                                   @"",                  @"img",
                                   nil] atIndex: 4];
        
        [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"marca",              @"DataKey",
                                   @"Marca auto da quotare",  @"placeholder",
                                   @"",                  @"img",
                                   nil] atIndex: 5];
        [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"modello",              @"DataKey",
                                   @"Modello auto",  @"placeholder",
                                   @"",                  @"img",
                                   nil] atIndex: 6];
        
    }
    else {
        [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"tipo",              @"DataKey",
                                   @"Tipologia elettromedicale",  @"placeholder",
                                   @"",                  @"img",
                                   nil] atIndex: 4];
        
        [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"prezzo",              @"DataKey",
                                   @"Prezzo imponibile",  @"placeholder",
                                   @"",                  @"img",
                                   nil] atIndex: 5];
    }
    
    self.sectionData = [[NSArray alloc] initWithObjects:secUserData, infoData, nil];
    self.sectionDescription = [[NSArray alloc] initWithObjects:@"I tuoi dati",@"Informativa",nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DataSourceDelegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];;
}


@end
