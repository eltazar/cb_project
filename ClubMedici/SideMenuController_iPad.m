//
//  SideMenuController_iPad.m
//  ClubMedici
//
//  Created by mario greco on 19/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "SideMenuController_iPad.h"
#import "AppDelegate.h"

@interface SideMenuController_iPad ()

@end

@implementation SideMenuController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"SideMenuController_iPad" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Menu";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - iOS 5 specific


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [cell setBackgroundColor:[UIColor blueColor]];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *dataKey    = [_dataModel valueForKey:@"DATA_KEY"   atIndexPath:indexPath];
    NSString *controller = [_dataModel valueForKey:@"CONTROLLER" atIndexPath:indexPath];
    Class controllerClass = NSClassFromString(controller);
    
    UINavigationController *detailNavController = nil;
    
    if([dataKey isEqualToString:@"news"]){
        HomeViewController *homeController = [HomeViewController idiomAllocInit];
        detailNavController = [[UINavigationController alloc] initWithRootViewController:homeController];
    }
    else if([dataKey isEqualToString:@"member"]){
        RichiestaIscrizioneController *richiestaController = [[controllerClass alloc] initWithNibName:@"FormViewController" bundle:nil];
        detailNavController = [[UINavigationController alloc] initWithRootViewController:richiestaController];
    
    }
    else if([dataKey isEqualToString:@"contacts"]){
        ContattiViewController *contattiController = [controllerClass idiomAllocInit];
        detailNavController = [[UINavigationController alloc] initWithRootViewController:contattiController];
    }
    else{
        //Ottengo la classe dell'oggetto della business logic da instanziare
        AreaBaseController *areaController = [controllerClass idiomAllocInit];
        detailNavController = [[UINavigationController alloc] initWithRootViewController:areaController];
        areaController.areaId = [[_dataModel valueForKey:@"ID" atIndexPath:indexPath] intValue];
        areaController.title = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
    }    
    
    //ricostruisco lo splitViewController con il nuovo detailController
    NSArray *viewControllers=[NSArray arrayWithObjects:[appDelegate.splitViewController.viewControllers objectAtIndex:0],detailNavController,nil];
    
    appDelegate.splitViewController.viewControllers = viewControllers;

    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
