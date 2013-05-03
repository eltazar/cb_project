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
    
    contactPanel.backgroundColor = [UIColor colorWithRed:207/255.0f green:216/255.0f blue:226/255.0f alpha:1];

    contattaciLabel.textColor = [UIColor colorWithRed:28/255.0f green:60/255.0f blue:119/255.0f alpha:1];
//    contattaciLabel.textColor     = [UIColor colorWithRed:207/255.0f green:216/255.0f blue:226/255.0f alpha:0.5];//[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
//    contattaciLabel.shadowColor   = [UIColor colorWithRed:43/255.0f green:86/255.0f blue:140/255.0f alpha:1];
//    contattaciLabel.shadowOffset  = CGSizeMake(-1.0,-1.0);
    
    contactPanel.layer.borderColor = [UIColor colorWithRed:78/255.0f green:111/255.0f blue:147/255.0f alpha:0.8].CGColor;
    contactPanel.layer.borderWidth = 0.8f;
    
    CALayer *innerLayer = [[CALayer alloc] init];
    innerLayer.frame = CGRectMake(2, 2, contactPanel.frame.size.width-4, contactPanel.frame.size.height-4);
    innerLayer.borderColor = [UIColor whiteColor].CGColor;
    innerLayer.borderWidth = 0.7f;
    
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

@end
