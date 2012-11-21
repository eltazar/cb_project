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

@interface SideMenuController_iPhone ()

@end

@implementation SideMenuController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *sec = [self.sectionData objectAtIndex:indexPath.section];
    NSDictionary *rowDesc = [sec objectAtIndex:indexPath.row];
    
    //Ottengo la classe dell'oggetto della business logic da instanziare
    NSString *classNameStr = [rowDesc objectForKey:@"DataKey"];
    Class theClass = NSClassFromString(classNameStr);
//    id myObject = [[theClass alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    /*NOTA:
     per ora instanzio il base controller in maniera specifica. andando avanti dovrò  fare una cosa simile a prima ricavandomi il nome della classe dalla stringa datakey, aggiungerci "Controller" e quindi instanziare un controller dinamicamente in base al datakey.. es: id theController = [theClassController alloc] init:.......];
     */
    //creo controller per l'area desiderata passandogli l'oggetto della logica di business
    AreaBaseController *areaController = [[AreaBaseController alloc] initWithArea:[[theClass alloc]init] ];

    [appDelegate.detailViewNavController popToRootViewControllerAnimated:NO];
    [appDelegate.detailViewNavController pushViewController:areaController animated:NO];
    [appDelegate.jasSidePanelController hideLeftPanel:self];
    
    
    
}


@end
