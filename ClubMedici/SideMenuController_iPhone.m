//
//  SideMenuController_iPhone.m
//  ClubMedici
//
//  Created by mario greco on 19/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "SideMenuController_iPhone.h"
#import "AppDelegate.h"
#import "AreaBaseController.h"
#import "AreaFinanziaria.h"
#import "JASidePanelController.h"
#import "AreaBaseController_iPhone.h"

@interface SideMenuController_iPhone ()

@end

@implementation SideMenuController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"SideMenuController_iPhone" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Menu       ";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *dataKey    = [_dataModel valueForKey:@"DATA_KEY"   atIndexPath:indexPath];
    NSString *controller = [_dataModel valueForKey:@"CONTROLLER" atIndexPath:indexPath];
    Class controllerClass = NSClassFromString(controller);
    
    appDelegate.jasSidePanelController.centerPanel = nil;
    
    if([dataKey isEqualToString:@"Azienda"]){
        appDelegate.jasSidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[HomeViewController idiomAllocInit]];
    }
    else if([dataKey isEqualToString:@"member"]){
        RichiestaIscrizioneController *richiestaController = [[controllerClass alloc] initWithNibName:@"FormViewController" bundle:nil];
        appDelegate.jasSidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:richiestaController];
    }
    else if([dataKey isEqualToString:@"contacts"]){
        ContattiViewController *contattiController = [controllerClass idiomAllocInit];
        appDelegate.jasSidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:contattiController];
    }
    else{
        //Ottengo la classe dell'oggetto della business logic da instanziare
        AreaBaseController *areaController = [controllerClass idiomAllocInit];
        areaController.areaId = [[_dataModel valueForKey:@"ID" atIndexPath:indexPath] intValue];
        areaController.title = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
        
        appDelegate.jasSidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:areaController];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
