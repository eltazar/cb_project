//
//  AreaBaseController_iPad.m
//  ClubMedici
//
//  Created by mario greco on 21/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//
#include <QuartzCore/QuartzCore.h>

#import "AreaBaseController_iPad.h"
#import "AreaBase.h"
#import "WMTableViewDataSource.h"
#import "AreaDescriptionCell.h"


#define PORTRAIT_WIDTH 447.0
#define LANDSCAPE_WIDTH 703.0


@interface AreaBaseController_iPad ()
{
    AreaDescriptionCell *_areaDescriptionCell;
}
@end

@implementation AreaBaseController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"ViewDidLoad: AreaBaseController_iPad");

    
    // Do any additional setup after loading the view from its nib.
    _areaDescriptionCell = [[[NSBundle mainBundle] loadNibNamed:@"AreaDescriptionCell_iPad"
                                                          owner:nil
                                                        options:nil] objectAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - iOS 5 specific

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self setupBackgroundView];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //NSString *cellIdentifier;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if ([dataKey isEqualToString:@"description"]) {
        _areaDescriptionCell.collapsedHeight = 120;
        _areaDescriptionCell.text = self.area.descrizione;
        return _areaDescriptionCell;

    }
    else {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        AreaDescriptionCell *cell = (AreaDescriptionCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell getHeight];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    
    if([dataKey isEqualToString:@"cure"]){
        //FormViewController *formController = [[FormViewController alloc] initWithNibName:@"FormViewController" bundle:nil];
        //[self.navigationController pushViewController:formController animated:YES];
        NSLog(@"CELLA CURE MEDICHE ---> devo lanciare calcolatore php");
        
    }
    else if([dataKey isEqualToString:@"noleggioAuto"] || [dataKey isEqualToString:@"noleggioElettro"] ||
            [dataKey isEqualToString:@"leasingElettro"]){
        
        NSLog(@" CELLA NOLEGGIO = %@", dataKey);
        RichiestaNoleggioController *formController = [[RichiestaNoleggioController alloc] init:dataKey];
        formController.delegate = self;
        
        /*che si fa?
         idea: mostrare il form con una modalview che è più piccola rispetto le dimensioni del controller che la contiene. pero in portrait e split view non la gestisce. solo in landscape.
         UINavigationController *navContr = [[UINavigationController alloc] initWithRootViewController:formController];
         navContr.modalPresentationStyle = UIModalPresentationPageSheet;
         [self.navigationController presentModalViewController:navContr  animated:YES];*/
        
        //Per ora mostro aggiungendo normalmente la nuova view alla gerarchia
        [self.navigationController pushViewController:formController animated:YES];        
    }        
    else{
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - FormViewControllerDelegate

-(void)didPressCancelButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - Private Methods

- (void) setupBackgroundView{
    
    
    [self computeImageSize];
    
    UIView *backgroundView = [[UIView alloc]init];
    
    [backgroundView addSubview:imageView];
    self.tableView.backgroundView = backgroundView;
     self.tableView.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];    
    //per fare in modo che l'immagine nell'header diventi trasparente gradualmente verso la fine dell'immagine stessaUIView *backgroundView = [[UIView alloc] init];
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = imageView.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    l.startPoint = CGPointMake(1.0f, .6f);
    l.endPoint = CGPointMake(1.0f, 1.0f);
    imageView.layer.mask = l;
    
    
    //per far iniziare la tableView con un offset
    [UIView animateWithDuration:.5
                     animations:^(void) {
                         self.tableView.tableHeaderView =
                         [[UIView alloc] initWithFrame:
                          CGRectMake(0, 0,
                                     imageView.frame.size.width,
                                     0.7 * imageView.frame.size.height
                                     )
                          ];
                     }
     ];
}

-(void) computeImageSize{
    
    CGFloat scaleFactor = 0.0;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    
    if(imageView.image.size.width == 0.0) return;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"portrait");
        scaleFactor = PORTRAIT_WIDTH / imageView.image.size.width;
        width = PORTRAIT_WIDTH;
        height = scaleFactor * imageView.image.size.height;
    }
    else{
        NSLog(@"landscape");
        scaleFactor = LANDSCAPE_WIDTH/imageView.image.size.width;
        height = scaleFactor * imageView.image.size.height;
        width = LANDSCAPE_WIDTH;
    }
    
    //NSLog(@"**** w = %f, h = %f",width, height);
    
    imageView.frame = CGRectMake(0, 0,
                                 width, height);
}

@end
