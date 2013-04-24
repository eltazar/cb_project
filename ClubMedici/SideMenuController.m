//
//  SideMenu.m
//  ClubMedici
//
//  Created by mario greco on 18/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import "SideMenuController.h"
#import "AppDelegate.h"
#import "AreaBaseController.h"
#import "UIViewController+InterfaceIdiom.h"
#import "JASidePanelController.h"
#import "RichiestaIscrizioneController.h"
#import "WMTableViewDataSource.h"
#import "ContattiViewController.h"
#import "AreaBase.h"


@interface SideMenuController() {
    WMTableViewDataSource *_dataModel;
}

@end

@implementation SideMenuController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        _dataModel = [[WMTableViewDataSource alloc] initWithPList:@"SideMenu"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //TODO: da sistemare la sua posizione nella navBar
    self.title = @"Menu";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //rimuove celle extra
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.dataSource = _dataModel;
    _dataModel.cellFactory = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    cell.textLabel.text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *dataKey    = [_dataModel valueForKey:@"DATA_KEY"   atIndexPath:indexPath];
    NSString *controller = [_dataModel valueForKey:@"CONTROLLER" atIndexPath:indexPath];
        
    if([dataKey isEqualToString:@"member"]){
        RichiestaIscrizioneController *richiestaController = [[RichiestaIscrizioneController alloc] initWithNibName:@"FormViewController" bundle:nil];
        [appDelegate.detailViewNavController popToRootViewControllerAnimated:NO];
        [appDelegate.detailViewNavController pushViewController:richiestaController animated:YES];
    }
    else if([dataKey isEqualToString:@"contacts"]){
        //Class controllerClass = NSClassFromString(controller);
        Class controllerClass = NSClassFromString(controller);
        ContattiViewController *contattiController = [controllerClass idiomAllocInit];
        [appDelegate.detailViewNavController popToRootViewControllerAnimated:NO];
        [appDelegate.detailViewNavController pushViewController:contattiController animated:YES];
    }
    else{
        //Ottengo la classe dell'oggetto della business logic da instanziare
        Class areaClass = NSClassFromString(dataKey);
        Class controllerClass = NSClassFromString(controller);
        
        AreaBaseController *areaController = [controllerClass idiomAllocInit];
        areaController.areaId = [[_dataModel valueForKey:@"ID" atIndexPath:indexPath] intValue];
        //AreaBase *area = [areaClass alloc];
        //area.titolo = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
        //areaController.area = area;
        areaController.title = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
        [appDelegate.detailViewNavController popToRootViewControllerAnimated:NO];
        [appDelegate.detailViewNavController pushViewController:areaController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [appDelegate.jasSidePanelController hideLeftPanel:self];
}

@end
