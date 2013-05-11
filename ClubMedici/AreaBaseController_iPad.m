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
#import "CustomSpinnerView.h"


#define PORTRAIT_WIDTH 447.0
#define LANDSCAPE_WIDTH 703.0


@interface AreaBaseController_iPad () { }
@end


@implementation AreaBaseController_iPad


- (id)init {
    self = [super init];
    if (self) {
        areaDescriptionCellCollapsedHeight = 120;
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



# pragma mark - iOS 5 specific



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self setupBackgroundView];
}




#pragma mark - TableViewDelegate



- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    if([dataKey isEqualToString:@"phone"])
        return YES;
    
    return NO;
}


- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    return (action == @selector(copy:));
}


- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)){
        NSLog(@"Copio in clipboard");
        NSString *text = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
        NSString *copyString = [[NSString alloc] initWithFormat:@"%@",text];
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:copyString];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if ([dataKey isEqualToString:@"phone"]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([dataKey isEqualToString:@"noleggioAuto"] ||
             [dataKey isEqualToString:@"noleggioElettro"] ||
             [dataKey isEqualToString:@"leasingElettro"]) {
        
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
    else {
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
    
    if (spinner.isVisible) {
        //se spinner era visibile lo rimuovo dalla vecchia backgroundView, e lo aggiungo a quella nuova
        [spinner removeFromSuperview];
        spinner.frame = CGRectMake(self.navigationController.navigationBar.frame.size.width/2 - spinner.frame.size.width/2, self.view.frame.size.height/2 - spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);

        //spinner.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2+100, spinner.frame.size.width, spinner.frame.size.height);
        [backgroundView addSubview: spinner];
    }
    
    self.tableView.backgroundView = backgroundView;
    self.tableView.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    
    //per fare in modo che l'immagine nell'header diventi trasparente gradualmente verso la fine dell'immagine stessa
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


- (void)computeImageSize {
    CGFloat scaleFactor = 0.0;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    
    if(imageView.image.size.width == 0.0) return;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"PORTRAIT");
        scaleFactor = PORTRAIT_WIDTH / imageView.image.size.width;
        width = PORTRAIT_WIDTH;
        height = scaleFactor * imageView.image.size.height;
    }
    else{
        NSLog(@"LANDSCAPE");
        scaleFactor = LANDSCAPE_WIDTH/imageView.image.size.width;
        height = scaleFactor * imageView.image.size.height;
        width = LANDSCAPE_WIDTH;
    }
        
    imageView.frame = CGRectMake(0, 0,
                                 width, height);
}


- (void)showErrorView:(NSString*)message {
    
    if (errorView == nil || !errorView.showed) {
        errorView = [[ErrorView alloc] initWithSize:self.view.frame.size];
        [super showErrorView:message];
    }
}

@end
