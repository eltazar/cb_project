//
//  FormViewController.m
//  ClubMedici
//
//  Created by mario greco on 22/11/12.
//  Copyright (c) 2012 mario greco. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "FormViewController.h"
#import "TextFieldCell.h"
#import "WMTableViewDataSource.h"
#import "ErrorView.h"
#import "AppDelegate.h"
#import "JASidePanelController.h"
#import "FXLabel.h"

#define KEYBOARD_ORIGIN_Y self.tableView.frame.size.height - 216.0f
#define BUTTON_Y 446+50 // il primo addendo è preso dal content_size_height della tabella una volta visualizzata

@interface FormViewController () {
    TextFieldCell *textFieldCell;
    JASidePanelController *jasController;
    IBOutlet FXLabel *headerLabel;
}

@end

@implementation FormViewController
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"Richiesta preventivo";

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //per staccare un po la prima cella dal bordo superiore
    self.tableView.contentInset = UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f);

    self.tableView.dataSource = _dataModel;
    _dataModel.cellFactory = self;
    _dataModel.showSectionHeaders = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Indietro" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0f green:250/255.0f blue:255/255.0f alpha:1];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    jasController = appDelegate.jasSidePanelController;
    
    [jasController addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    
    headerLabel.textColor = [UIColor colorWithWhite:0.4f alpha:1];
    headerLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    headerLabel.shadowOffset = CGSizeMake(0.8f, 0.80f);
    headerLabel.shadowBlur = 1.0f;
    headerLabel.innerShadowBlur = 3.0f;
    headerLabel.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
    headerLabel.innerShadowOffset = CGSizeMake(0.8f, 0.8f);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){

        UIImage* buttonImage = [[UIImage imageNamed:@"normal_button_big.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
        
        UIImage* buttonPressedImage = [[UIImage imageNamed:@"normal_button_big_selected.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = CGRectMake(0.0, 0.0, 150.0, buttonImage.size.height);
        [sendButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [sendButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
        [sendButton setTitle:@"Invia" forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sendButton];
        [self setButtonsInView];
    }
    else{
        //pulsante INVIA sulla navBar, magari in futuro riservirà
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Invia" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonPressed:)];
        self.navigationItem.rightBarButtonItem = button;
    }
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    @try{
        [jasController removeObserver:self forKeyPath:@"state"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
        NSLog(@"TRY CATCH");
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"APPEAR content offset y = %f",self.tableView.contentSize.height);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//ios5 rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return NO;
        
    return YES;
}

//io6 rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)  interfaceOrientation duration:(NSTimeInterval)duration{
    
    NSLog(@"ROTAZIONE");
    
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
         return;
    [self setButtonsInView];
}

-(void) setButtonsInView{
    sendButton.frame = CGRectMake(self.navigationController.navigationBar.frame.size.width/2 - sendButton.frame.size.width/2, BUTTON_Y, sendButton.frame.size.width, sendButton.frame.size.height);
    //CGRectMake(x,BUTTON_Y,sendButton.frame.size.width,sendButton.frame.size.height);
}

#pragma mark - Buttons method


- (void)sendButtonPressed:(id)sender {
    //NSLog(@"SEND BUTTON PRESSED");
    
    //fa si che il testo inserito nei texfield sia preso anche se non è stata dismessa la keyboard
    [self.view endEditing:TRUE];
    
    if([Utilities networkReachable]){
        if([self validateFields]){
            [self sendRequest];
        }
    }
    else{
        //mostra avviso rete assente
        NSLog(@"rete assente");
        [self showErrorView:@"Connessione assente"];
    }
}

-(NSString*)createHtmlBody{
    return nil;
}

-(void)sendRequest{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Invio...";
}

- (void) cancelButtonPressed:(id)sender {
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    if(delegate && [delegate respondsToSelector:@selector(didPressCancelButton:)]){
        [delegate didPressCancelButton:self];
    }
}

-(BOOL)validateFields{
    return FALSE;
}

-(void)showDisclaimer{
    DisclaimerController *disclaimerCntr = [[DisclaimerController alloc] initWithNibName:@"DisclaimerController" bundle:nil];
    [self.navigationController pushViewController:disclaimerCntr animated:YES];
}

//per annullare editing cliccando ovunque nella view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"ciaooo");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // called when "Next" is pressed
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(TextFieldCell*)[[textField superview]superview]];
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
    
    if(nextIndexPath.row < [self.tableView numberOfRowsInSection:0])
        [[((TextFieldCell*)[self.tableView cellForRowAtIndexPath:nextIndexPath]) viewWithTag:1] becomeFirstResponder];
    else{
        [textField resignFirstResponder];
        //riporta tabella a offset originale
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             self.tableView.contentOffset = CGPointMake(0, -60);
                         }
         ];
    };
    
    //NSLog(@"textFieldShouldReturn row = %d",indexPath.row);
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    //NSLog(@"y = %f", cell.frame.origin.y);
    
    if(cell.frame.origin.y + textField.frame.size.height >= KEYBOARD_ORIGIN_Y){
        //modifica offset per fare vedere celle nascoste
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y+60);
                         }
         ];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSString *dataKey = [_dataModel valueForKey:@"DATA_KEY" atIndexPath:indexPath];
    
    if ([dataKey isEqualToString:@"info"]) {
        // Sezione 1
        cell = [tableView dequeueReusableCellWithIdentifier:@"Disclaimer"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DisclaimerCell" owner:self options:NULL] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *disclaimerBtn = (UIButton *)[cell viewWithTag:10];
        [disclaimerBtn addTarget:self action:@selector(showDisclaimer) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        // Sezione 0
        //NSLog(@"FormCell %@", indexPath);
        cell = [tableView dequeueReusableCellWithIdentifier:@"FormCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:NULL] objectAtIndex:0];
        }
        
        UITextField *textField = (UITextField*)[cell viewWithTag:1];
        textField.delegate = self;
        textField.placeholder = [_dataModel valueForKey:@"PLACEHOLDER" atIndexPath:indexPath];
        
        if([dataKey isEqualToString:@"email"]){
            [textField setKeyboardType:UIKeyboardTypeEmailAddress];
        }
        else if([dataKey isEqualToString:@"phone"] ||
                [dataKey isEqualToString:@"cell"] || [dataKey isEqualToString:@"iva"]){
            [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        }
    }
    return cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - WMHTPPAccessDelegate 
-(void)didReceiveString:(NSString *)receivedString{
    NSLog(@"Invio mail esito positivo: %@",receivedString);
    if(errorView && errorView.showed){
        [self hideErrorView:nil];
    }
    
    if([receivedString isEqualToString:@"ok"]){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"Richiesta inviata!";
        hud.mode = MBProgressHUDModeText;

        [hud hide:YES afterDelay:2.4];
    }
    else{
        [self didReceiveError:nil];
    }
}
-(void)didReceiveError:(NSError *)error{
    NSLog(@"Invio mail errore");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    //hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.labelText = @"Errore, riprova";
//    hud.mode = MBProgressHUDModeText;
//    [hud hide:YES afterDelay:2.4];
    [self showErrorView:@"Errore server, riprovare"];
}

#pragma mark - ErrorView methods
-(void)hideErrorView:(UITapGestureRecognizer*)gesture{
    if(errorView || errorView.showed){
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             [errorView setFrame:CGRectMake(0, 43, errorView.frame.size.width,0)];
                         }
         ];
        errorView.showed = NO;
    }
}

-(void)showErrorView:(NSString*)message{
    
        if(errorView == nil || !errorView.showed){
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                errorView = [[ErrorView alloc] init];
            }
            else{
                errorView = [[ErrorView alloc] initWithSize:self.view.frame.size];
            }
            errorView.label.text = message;
            [errorView.tapRecognizer addTarget:self action:@selector(hideErrorView:)];
            
            CGRect oldFrame = [errorView frame];
            [errorView setFrame:CGRectMake(0, 43, oldFrame.size.width, 0)];
            
            [self.navigationController.view addSubview:errorView];
            
            [UIView animateWithDuration:0.5
                             animations:^(void){
                                 [errorView setFrame:CGRectMake(0, 43, oldFrame.size.width, oldFrame.size.height)];
                             }
             ];
            errorView.showed = YES;
        }

}

#pragma mark - Private methods 

-(void)hideKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - KVO handler
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"state"]){
        if(JASidePanelLeftVisible == [[change objectForKey:NSKeyValueChangeNewKey] intValue]){
            NSLog(@"FormViewController: JASSidePanelLeft mostrato");
            [self hideKeyboard];
        }
    }
}
@end
