//
//  AreaController_iPhone.m
//  ClubMedici
//
//  Created by mario greco on 23/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>

#import "AreaDescriptionCell.h"
#import "AreaBaseController_iPhone.h"
#import "AreaBase.h"
#import "WMTableViewDataSource.h"

#import "Reachability.h"

@interface AreaBaseController_iPhone () {
    NSString *phoneNumber;
}
@end

@implementation AreaBaseController_iPhone


- (id)init {
    self = [super init];
    if (self) {
        areaDescriptionCellCollapsedHeight = 70;
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



# pragma mark - iOS 5 specific



- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation {
    // per gestire rotazione guardare qui:
    // http://stackoverflow.com/questions/12536645/rotation-behaving-differently-on-ios6
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - TableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if ([dataKey isEqualToString:@"phone"]) {
            phoneNumber = [_dataModel valueForKey:@"LABEL" atIndexPath:indexPath];
            [self callNumber: phoneNumber];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if([dataKey isEqualToString:@"noleggioAuto"] ||
            [dataKey isEqualToString:@"noleggioElettro"] ||
            [dataKey isEqualToString:@"leasingElettro"]) {
        
        //NSLog(@" CELLA NOLEGGIO = %@", dataKey);
        RichiestaNoleggioController *formController = [[RichiestaNoleggioController alloc] init:dataKey];
        formController.delegate = self;

        [self.navigationController presentModalViewController:[[UINavigationController alloc]initWithRootViewController:formController] animated:YES];
    }
    else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}



#pragma mark - FormViewControllerDelegate



-(void)didPressCancelButton:(id)sender{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}



# pragma mark - Private Methods



- (void)setupBackgroundView {
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
    if(imageView.image.size.width != 0){
        CGFloat tableViewWidth = self.tableView.frame.size.width;
        UIView *backgroundView = [[UIView alloc]init];
        imageView.frame = CGRectMake(0, 0,
                                     tableViewWidth,    
                                     tableViewWidth * (imageView.image.size.height / imageView.image.size.width)
                                     );
        [backgroundView addSubview:imageView];
        self.tableView.backgroundView = backgroundView;
        self.tableView.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1];
        
        //per fare in modo che l'immagine nell'header diventi trasparente gradualmente verso la fine dell'immagine stessaUIView *backgroundView = [[UIView alloc] init];
        CAGradientLayer *l = [CAGradientLayer layer];
        l.frame = imageView.bounds;
        l.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
        l.startPoint = CGPointMake(1.0f, .6f);
        l.endPoint = CGPointMake(1.0f, 1.0f);
        imageView.layer.mask = l;
        
        
        //per far iniziare la tableView con un offset
        self.tableView.tableHeaderView =
        [[UIView alloc] initWithFrame:
         CGRectMake(0, 0,
                    tableViewWidth,
                    0.6 * imageView.frame.size.height
                    )
         ];
        
        //per far iniziare la tableView con un offset e animazione
        /*[UIView animateWithDuration:.5
                         animations:^(void) {
                             self.tableView.tableHeaderView =
                             [[UIView alloc] initWithFrame:
                              CGRectMake(0, 0,
                                         tableViewWidth,
                                         0.5 * imageView.frame.size.height
                                         )
                              ];
                         }
         ];*/
        
    }
    //NSLog(@"frame.width = %f, height = %f", tableViewWidth,backgroundView.frame.size.height);
}


- (void)computeImageSize {

}


- (void)showErrorView:(NSString*)message {
    if(errorView == nil || !errorView.showed){
        errorView = [[ErrorView alloc] init];
        [super showErrorView:message];
    }
}


- (void)callNumber:(NSString*)number {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Chiamare %@ ?",number] message:nil delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"Chiama", nil];
    [alert show];
}






#pragma mark - UIAlertViewDelegate



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [Utilities callNumber:phoneNumber];
    }
}



#pragma mark - UIScrollViewDelegate



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //per far rimanere l'errorView sempre nella stessa posizione mentre scrollo la tableView
    //errorView.frame = CGRectMake(0, self.tableView.contentOffset.y , [errorView getFrame].size.width, [errorView getFrame].size.height);
}







@end
