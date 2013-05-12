//
//  DescrizioneAreaController.m
//  ClubMedici
//
//  Created by mario on 23/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DocumentoAreaController_iPhone.h"

@interface DocumentoAreaController_iPhone ()
{
    IBOutlet UIView *contactPanel;
    IBOutlet UILabel *contattaciLabel;
}
@end

@implementation DocumentoAreaController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) init{
    
    self = [self initWithNibName:@"DocumentoAreaController_iPhone" bundle:nil];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    contattaciLabel.textColor = [UIColor whiteColor];//[UIColor colorWithRed:28/255.0f green:60/255.0f blue:119/255.0f alpha:1];
//    contattaciLabel.textColor     = [UIColor colorWithRed:207/255.0f green:216/255.0f blue:226/255.0f alpha:0.5];//[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
//    contattaciLabel.shadowColor   = [UIColor colorWithRed:43/255.0f green:86/255.0f blue:140/255.0f alpha:1];
//    contattaciLabel.shadowOffset  = CGSizeMake(-1.0,-1.0);
    
    contactPanel.layer.borderColor = [UIColor colorWithRed:28/255.0f green:57/255.0f blue:109/255.0f alpha:1].CGColor;
    contactPanel.layer.borderWidth = 1;
    
    CALayer *innerLayer = [[CALayer alloc] init];
    innerLayer.frame = CGRectMake(0, 1, contactPanel.frame.size.width, contactPanel.frame.size.height-2);
    innerLayer.borderColor = [UIColor colorWithRed:37/255.0f green:86/255.0f blue:172/255.0f alpha:0.9f].CGColor;
//[UIColor whiteColor].CGColor;
    innerLayer.borderWidth = 0.8f;
    
    [contactPanel.layer addSublayer:innerLayer];
    contactPanel.layer.masksToBounds = NO;
    //contactPanel.layer.cornerRadius = 8; // if you like rounded corners
    contactPanel.layer.shadowOffset = CGSizeMake(0.5f, -3);
    contactPanel.layer.shadowRadius = 1;
    contactPanel.layer.shadowOpacity = 0.3;
    
    _titolo.text = self.title;
    _titolo.backgroundColor = [UIColor colorWithRed:207/255.0f green:216/255.0f blue:226/255.0f alpha:1];
    _titolo.textColor = [UIColor colorWithRed:28/255.0f green:60/255.0f blue:119/255.0f alpha:1];
    _titolo.layer.masksToBounds = NO;
    _titolo.layer.shadowOffset = CGSizeMake(0.5f,3);
    _titolo.layer.shadowRadius = 0.6f;
    _titolo.layer.shadowOpacity = 0.3;
    
    UISwipeGestureRecognizer *swipeGestue = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBackWithSwipe:)];
    [swipeGestue setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGestue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showErrorView:(NSString*)message{
    
    if(errorView == nil || !errorView.showed){
        errorView = [[ErrorView alloc] init];
        [super showErrorView:message];
    }
}

-(void)goBackWithSwipe:(UISwipeGestureRecognizer*)gesture{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)callNumber{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Chiamare %@ ?",phone] message:nil delegate:self cancelButtonTitle:@"Annulla" otherButtonTitles:@"Chiama", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [Utilities callNumber:phone];
    }
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
    
    NSString *style = @"body {font-family:helvetica;margin:15px 15px 15px 15px;background-color: #f3f4f5;}body,p {font-size: 17px;color: #333333;text-shadow: #fff 0px 1px 0px;}h1, h2, h3, h4, h5, h6 {            \
    margin: 0;                      \
    font-family: helvetica;         \
    font-size:. 115%;               \
    color: #0D4383;\
    text-shadow: rgba(0,0,0,0.5) -0.5px 0, rgba(0,0,0,0.3) 0 -0.5px, rgba(255,255,255,0.5) 0.5px, rgba(0,0,0,0.3) -0.5px -0.5px;\
    }";
    //font-size: 16px;text-align: justify;color: #272727;text-shadow: 1px 4px 6px #f6faff, 0 0 0 #000, 1px 4px 6px #f6faff;}";//
    htmlPage = [NSString stringWithFormat:htmlPage, style, self.title,htmlString];
    [self.webView loadHTMLString:htmlPage baseURL:[NSURL URLWithString:nil]];
}

@end
