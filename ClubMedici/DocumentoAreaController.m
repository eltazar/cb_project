//
//  DocumentoAreaController.m
//  ClubMedici
//
//  Created by mario on 30/04/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "DocumentoAreaController.h"
#import "PDHTTPAccess.h"
#import "Utilities.h"

@interface DocumentoAreaController ()

@end

@implementation DocumentoAreaController
@synthesize webView, idPag;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [PDHTTPAccess getDocumentContents:[idPag intValue] delegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WMHTTPAccessDelegate

-(void)didReceiveJSON:(NSArray *)jsonArray{
    NSLog(@"JSON DESC : %@",jsonArray);
    NSString *htmlString = [[jsonArray objectAtIndex:0] objectForKey:@"testo"];
    mail = [[jsonArray objectAtIndex:0] objectForKey:@"email"];
    phone = [[jsonArray objectAtIndex:0] objectForKey:@"telefono"];
    [webView loadHTMLString:htmlString baseURL:nil];
    
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"Error json = %@",error.description);
}

#pragma mark - UIButton methods

-(IBAction) writeEmail{
    [Utilities sendEmail:mail controller:self];
}

-(IBAction)callNumber{
    [Utilities callNumber:phone];
}

#pragma mark - MFMailComposeViewControllerDelegate


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissModalViewControllerAnimated:YES];
    if(result == MFMailComposeResultSent) {
        NSLog(@"messaggio inviato");
    }
	else if (result == MFMailComposeResultFailed){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messaggio non inviato!" message:@"Non è stato possibile inviare la tua e-mail" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil];
		[alert show];
	}
    else if (result == MFMailComposeResultCancelled){
        NSLog(@"messaggio annullato");
    }
}

@end
