//
//  SharingProvider.m
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 10/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <Social/Social.h>
#import <Twitter/Twitter.h>

#import "SharingProvider.h"
#import "AppDelegate.h"
#import "Utilities.h"

@interface SharingProvider(){
    UIActionSheet *actionSheet;
    BOOL isSocial;
}
@end

@implementation SharingProvider


- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sessionStateChanged:)      name:FBSessionStateChangedNotification
                                                   object:nil];
    }
    return self;
}

- (id)initWithSocial:(BOOL)social{
    
    self = [self init];
    if(self){
        isSocial = social;
    }
    return self;
}

#pragma mark - SHARING



- (IBAction)sharingAction:(id)sender {
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        //lancio activity di sharing di ios6
        [self shareWithIosActivity];
    }
    else {
        //lancio actionSheet custom
        [self shareWithActionSheet:sender];
    }
}


- (void)postToFacebook:(id)sender {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        //ios 6
        [self postWithIos6Api:SLServiceTypeFacebook];
    }
    else {
        //ios5
        [self authButtonAction:self];
    }
}


- (void)postToTwitter:(id)sender {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        //ios 6
        [self postWithIos6Api:SLServiceTypeTwitter];
    }
    else {
        //ios5
        [self twitter:self];
    }
}


- (void)postToMail:(id)sender {
    /*NSString *urlString = [NSString stringWithFormat:@"Ciao leggi la nuova news di ClubMedici:\n%@%@",URL_NEWS,[[json objectAtIndex:0] objectForKey:@"id"]];
     [Utilities sendEmail:nil object:[NSString stringWithFormat:@"News ClubMedici: \n%@",[[json objectAtIndex:0] objectForKey:@"titolo"]] content:urlString html:NO controller:self];*/
    [Utilities sendEmail:nil                   object:self.mailObject
                 content:self.mailBody           html:NO
              controller:self.viewController delegate:self];
}




# pragma mark - ### iOS 6.0



- (void)shareWithIosActivity {
    NSArray *activityItems;
        
    if(self.printView)
        activityItems = @[self.iOS6String, self.printView];
    else activityItems = @[self.iOS6String];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    if(isSocial){
        activityController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard,UIActivityTypePostToWeibo];

    }
    else{
        activityController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeCopyToPasteboard,UIActivityTypePostToWeibo];
    }
    
    [self.viewController presentViewController:activityController animated:YES completion:nil];
   
    
    //TODO: blocco da gestire per dare feedback all'utente
    /*[activityController setCompletionHandler:^(NSString *act, BOOL done)
     {
         NSString *ServiceMsg = nil;
         if ( [act isEqualToString:UIActivityTypeMail] )           ServiceMsg = @"Mail sended!";
         if ( [act isEqualToString:UIActivityTypePostToTwitter] )  ServiceMsg = @"Post on twitter, ok!";
         if ( [act isEqualToString:UIActivityTypePostToFacebook] ) ServiceMsg = @"Post on facebook, ok!";
         if ( [act isEqualToString:UIActivityTypeMessage] )        ServiceMsg = @"SMS sended!";
         if ( done )
         {
             UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:ServiceMsg message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
             [Alert show];
         }
     }];*/
}


- (void)postWithIos6Api:(NSString*)service {
    // È sia per Facebook che per Twitter
    SLComposeViewController *fbController = [SLComposeViewController composeViewControllerForServiceType:service];
    
    if([SLComposeViewController isAvailableForServiceType:service])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                    //TODO: mostrare hud successo
                }
                    break;
            }};
        
        //[fbController addImage:[UIImage imageNamed:@"1.jpg"]];
        [fbController setInitialText:/*[NSString stringWithFormat:@"News ClubMedici: \n%@",[[json objectAtIndex:0] objectForKey:@"titolo"]]*/self.initialText];
        [fbController addURL:[NSURL URLWithString:/*[NSString stringWithFormat:@"http://www.clubmedici.it/nuovo/pagina.php?art=1&pgat=%@",[[json objectAtIndex:0] objectForKey:@"id"]]*/self.url]];
        [fbController setCompletionHandler:completionHandler];
        [self.viewController presentViewController:fbController animated:YES completion:nil];
    }
    
}




#pragma mark - ### iOS 5.0



- (void)shareWithActionSheet:(id)sender {
    NSLog(@"ACTION SHEET");
    //TODO: andare a pescare la roba iPad
    
    if([actionSheet isVisible] && [self.viewController respondsToSelector:@selector(dismissShareActionSheet:sender:)]){
        [self.viewController performSelector:@selector(dismissShareActionSheet:sender:) withObject:actionSheet withObject:sender];
        return;
    }

    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Condividi" delegate:self cancelButtonTitle:@"Annulla" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter",@"E-mail", nil];
    actionSheet.delegate = self;
    if ([self.viewController respondsToSelector:@selector(showShareActionSheet:sender:)]) {
        [self.viewController performSelector:@selector(showShareActionSheet:sender:) withObject:actionSheet withObject:sender];
    }
    else {
        [actionSheet showInView:self.viewController.view];
    }
}


- (IBAction)twitter:(id)sender {
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    [twitter setInitialText:/*[NSString stringWithFormat:@"News ClubMedici: \n%@",[[json objectAtIndex:0] objectForKey:@"titolo"]]*/self.initialText];
    //[twitter addImage:[UIImage imageNamed:@"image.png"]];
    [twitter addURL:[NSURL URLWithString:/*[NSString stringWithFormat:@"%@%@",URL_NEWS,[[json objectAtIndex:0] objectForKey:@"id"]]*/self.url]];
    
    [self.viewController presentViewController:twitter animated:YES completion:nil];
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        
        if(res == TWTweetComposeViewControllerResultDone) {
            NSLog(@"tweet inviato");
        }
        else if(res == TWTweetComposeViewControllerResultCancelled) {
            NSLog(@"tweet annullato");
        }
        [self.viewController dismissModalViewControllerAnimated:YES];
    };
}


- (void)authButtonAction:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    //[appDelegate openSessionWithAllowLoginUI:YES];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        //inizia la procedura di pubblicazione
        [self publishAction:self];
    } else {
        //lancia il login a facebook
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}


- (void)publishAction:(id)sender {
    // Put together the dialog parameters
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:@"News ClubMedici",   @"name",
                                                        self.title,         @"caption",
                                                        self.url,           @"link",
                                                        self.image,         @"picture", nil];
     
     /*@"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",*/
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     //TODO: mostrare hud di successo
                 }
             }
         }
     }];
}



#pragma mark - Facebook Observer



- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self postToFacebook:self];
    }
}



#pragma mark - ActionSheetDelegate



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self postToFacebook:self];
            break;
        case 1:
            [self postToTwitter:self];
            break;
        case 2:
            [self postToMail:self];
            break;
        default:
            break;
    }
}



#pragma mark - MFMailComposeViewControllerDelegate


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self.viewController dismissModalViewControllerAnimated:YES];
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



# pragma mark - Private Methods



/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}




@end
