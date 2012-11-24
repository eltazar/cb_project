//
//  RichiestaIscrizioneController.m
//  ClubMedici
//
//  Created by mario greco on 23/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "RichiestaIscrizioneController.h"

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
	// Do any additional setup after loading the view.
    
    NSMutableArray *secUserData = [[NSMutableArray alloc] init];
    NSMutableArray *infoData = [[NSMutableArray alloc] init];
    
    self.title = @"Richiesta iscrizione";
    
    
    [infoData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                            @"info",              @"DataKey",
                            @"",                  @"img",
                            nil] atIndex: 0];
    
    
    [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"name",              @"DataKey",
                               @"Nome",  @"placeholder",
                               @"",                  @"img",
                               nil] atIndex: 0];
    
    [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"surname",              @"DataKey",
                               @"Cognome",  @"placeholder",
                               @"",                  @"img",
                               nil] atIndex: 1];
    
    [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"email",              @"DataKey",
                               @"E-mail",  @"placeholder",
                               @"",                  @"img",
                               nil] atIndex: 2];
    
    [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"phone",              @"DataKey",
                               @"Telefono",  @"placeholder",
                               @"",                  @"img",
                               nil] atIndex: 3];
    
    [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"data",              @"DataKey",
                               @"Data di nascita",  @"placeholder",
                               @"",                  @"img",
                               nil] atIndex: 4];
    [secUserData insertObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                               @"place",              @"DataKey",
                               @"Luogo di nascita",  @"placeholder",
                               @"",                  @"img",
                               nil] atIndex: 5];

    
    self.sectionData = [[NSArray alloc] initWithObjects:secUserData, infoData, nil];
    self.sectionDescription = [[NSArray alloc] initWithObjects:@"I tuoi dati",@"Informativa",nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataSourceDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end
