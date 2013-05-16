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
    
    //nslog(@"ROTAZIONE");
    
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

#pragma mark - WMHTTPAccessDelegate
-(void)didReceiveJSON:(NSArray *)jsonArray{
    [super didReceiveJSON:jsonArray];
    NSString *htmlString = [[jsonArray objectAtIndex:0] objectForKey:@"testo"];
    
    htmlPage = @"<html>                                     \
    <head>                                  \
    <style type=\"text/css\">%@</style> \
    </head>                                 \
    <body>                              \
    <h3>%@</h3> %@              \
    </body></html>";
    
    NSString *style = @"body {font-family:helvetica;margin:15px 15px 15px 15px;background-color: #f3f4f5;}body,p {font-size: 18px;color: #333333;text-shadow: #fff 0px 1px 0px;} \
    h1, h2, h3, h4, h5, h6 {            \
    margin: 0;                      \
    font-family: helvetica;         \
    font-size:. 115%;               \
    color: #0D4383;\
    text-shadow: rgba(0,0,0,0.5) -0.5px 0, rgba(0,0,0,0.3) 0 -0.5px, rgba(255,255,255,0.5) 0.5px, rgba(0,0,0,0.3) -0.5px -0.5px;\
    }";
    //font-size: 16px;text-align: justify;color: #272727;text-shadow: 1px 4px 6px #f6faff, 0 0 0 #000, 1px 4px 6px #f6faff;}";//
    htmlPage = [NSString stringWithFormat:htmlPage,style,self.title,htmlString];
    [self.webView loadHTMLString:htmlPage baseURL:[NSURL URLWithString:nil]];
}

#pragma mark - SharingProvider informal protocol

-(void)showShareActionSheet:(UIActionSheet *)actionSheet sender:(UIBarButtonItem *)sender {
    
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

-(void)dismissShareActionSheet:(UIActionSheet *)actionSheet sender:(UIBarButtonItem *)sender {
    
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


@end
