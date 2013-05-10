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
@property(nonatomic, strong) NSString *iOS6String;
@property(nonatomic, strong) NSString *mailObject;
@property(nonatomic, strong) NSString *mailBody;
@property(nonatomic, strong) NSString *initialText;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *image;


@end
