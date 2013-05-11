//
//  TurismoItemController.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 11/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import "TurismoItemController.h"
#import "SharingProvider.h"

@interface TurismoItemController () {
    UIWebView *_webView;
    SharingProvider *_sharingProvider;
}

@end

@implementation TurismoItemController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _sharingProvider = [[SharingProvider alloc] init];
        _sharingProvider.viewController = self;
    }
    return self;
}



#pragma mark - View Lifecycle



- (void)viewDidLoad {
    // L'assegnazione doppia serve ad evitare un release prematuro, essendo la property weak.
	self.webView = _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    self.title = self.areaTurismoItem.title;
    self.urlString = self.areaTurismoItem.pdfUrl;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)];
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    self.webView.frame = self.view.frame;
    self.webView.superview.autoresizesSubviews = YES;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



# pragma mark - iOS 5 specific



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation {
    self.webView.frame = self.view.frame;
}



#pragma mark - SharingProvider informal protocol



- (void)showShareActionSheet:(UIActionSheet *)actionSheet sender:(UIBarButtonItem *)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [actionSheet showFromBarButtonItem:sender animated:YES];
    }
    else {
        [actionSheet showInView:self.view];
    }
}




#pragma mark - Private Methods



- (void)actionButtonPressed:(id)sender {
    _sharingProvider.iOS6String  = [NSString stringWithFormat:
                                    @"Offerta Turismo ClubMedici: %@\n %@",
                                    self.areaTurismoItem.title,
                                    self.areaTurismoItem.pdfUrl];
    
    _sharingProvider.mailObject  = [NSString stringWithFormat:
                                    @"Offerta Turismo ClubMedici: %@",
                                    self.areaTurismoItem.title];
    
    _sharingProvider.mailBody    = [NSString stringWithFormat:
                                    @"Ciao, leggi l'offerta turismo di ClubMedici:\n%@",
                                    self.areaTurismoItem.pdfUrl];
    
    _sharingProvider.initialText = [NSString stringWithFormat:
                                    @"Offerta Turismo ClubMedici: %@",
                                    self.areaTurismoItem.title];
    
    _sharingProvider.url         = [NSString stringWithFormat:@"%@",
                                    self.areaTurismoItem.pdfUrl];
    
    _sharingProvider.title       = self.areaTurismoItem.title;
    
    _sharingProvider.image       = self.areaTurismoItem.imageUrl;
    NSLog(@"imageUrl: %@", self.areaTurismoItem.imageUrl);
    
    [_sharingProvider sharingAction:sender];

}

@end
