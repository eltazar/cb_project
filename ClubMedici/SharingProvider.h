//
//  SharingProvider.h
//  ClubMedici
//
//  Created by Gabriele "Whisky" Visconti on 10/05/13.
//  Copyright (c) 2013 mario greco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@interface SharingProvider : NSObject<MFMailComposeViewControllerDelegate,
                                      UIActionSheetDelegate>

@property(nonatomic, weak) UIViewController* viewController;
//Ios6string: stringa contentente titolo+descrizione da condividere
@property(nonatomic, strong) NSString *iOS6String;
//Oggetti per la condivisione con ios5
@property(nonatomic, strong) NSString *mailObject;
@property(nonatomic, strong) NSString *mailBody;
//InitialText: titolo+contenuto per ios5
@property(nonatomic, strong) NSString *initialText;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *image;

- (id)initWithSocial:(BOOL)social;
- (IBAction)sharingAction:(id)sender;

@end
