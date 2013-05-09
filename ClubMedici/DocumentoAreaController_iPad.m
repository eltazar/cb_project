//
//  DocumentoAreaController_ipadViewController.m
//  ClubMedici
//
//  Created by mario on 30/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "DocumentoAreaController_iPad.h"

@interface DocumentoAreaController_iPad ()
@end

@implementation DocumentoAreaController_iPad

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)  interfaceOrientation duration:(NSTimeInterval)duration{
    
    NSLog(@"ROTAZIONE");
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return;
    spinner.frame = CGRectMake(self.navigationController.navigationBar.frame.size.width/2 - spinner.frame.size.width/2, self.view.frame.size.height/2 - spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
}


-(void)showErrorView:(NSString*)message{
    
    if(errorView == nil || !errorView.showed){
        errorView = [[ErrorView alloc] initWithSize:self.view.frame.size];
        [super showErrorView:message];
    }
}

#pragma mark - Copy methods

-(void)callNumber{
    [self becomeFirstResponder];
    
    /*get the view from the UIBarButtonItem*/
    //UIView *buttonView=[[event.allTouches anyObject] view];
    //CGRect buttonFrame= [self.callButton convertRect:self.callButton.frame toView:footerView];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    NSString *title = [NSString stringWithFormat:@"Copia %@",phone];
    UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:title action:@selector(menuItemClicked:)];
    
    NSAssert([self becomeFirstResponder], @"Sorry, UIMenuController will not work with %@ since it cannot become first responder", self);
    [menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
    [menuController setTargetRect:self.callButton.frame inView:self.callButton.superview];
    [menuController setMenuVisible:YES animated:YES];
    
}

- (void) menuItemClicked:(id) sender {
    // called when Item clicked in menu
    [[UIPasteboard generalPasteboard] setString:phone];
}
- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(menuItemClicked:) /*selector == @selector(copy:)*/){//*<--enable that if you want the copy item */) {
        return YES;
    }
    return NO;
}
- (BOOL) canBecomeFirstResponder {
    return YES;
}

@end
