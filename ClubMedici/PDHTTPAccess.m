//
//  PDHTTPAccess.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDHTTPAccess.h"

@interface PDHTTPAccess() {}
    + (NSString *)buildUrl:(NSString *)url;
@end


@implementation PDHTTPAccess

NSString *baseUrl = @"http://www.clubmedici.it/app/iphone/";

+ (void)getNews:(int)limit delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSString *urlString = [PDHTTPAccess buildUrl:@"News.php"];
    
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:limit], @"limit",
                              nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];

}


+(void)getAreaContents:(int)areaId delegate:(id<WMHTTPAccessDelegate>)delegate {
    //NSLog(@"DBACCESS REGISTER  --> user = %@", userData);
    
    //NSLog(@"AREA ID = %d",areaId);
    NSString *urlString = [PDHTTPAccess buildUrl:@"ContenutiAree.php"];
    
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:areaId], @"areaId",
                              nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


+ (void)getDocumentContents:(int)pagId delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSString *urlString = [PDHTTPAccess buildUrl:@"DescrizioneDocumento.php"];
    
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:pagId], @"idPagina",
                              nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];    
}


+ (void)sendEmail:(NSString*)body object:(NSString*)object address:(NSString*)address delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSString *urlString = [PDHTTPAccess buildUrl:@"InvioEmail.php"];
    
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              body, @"body",
                              object, @"oggetto",
                              address, @"indirizzo",
                              nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


+ (void)getAreaTurismoDataForSectionId:(NSInteger)sectionId inItaly:(BOOL)inItaly delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSString *urlString = [PDHTTPAccess buildUrl:@"Turismo.php"];
    
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%d", sectionId],  @"sectionId",
                              inItaly?@"1":@"0",                             @"italy",
                              nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}



#pragma mark - Private Methods


+ (NSString *)buildUrl:(NSString *)url {
    return [NSString stringWithFormat:@"%@%@", baseUrl, url];
}


/*
+ (void)checkUserFields:(NSArray*)usr delegate:(id<WMHTTPAccessDelegate>)delegate {
    //NSLog(@"DBACCESS CHECK  EMAIL --> user = %@",usr);
    
    NSString *urlString = @"";
    NSDictionary *postDict = nil;
    
    if (usr.count == 1) {
        urlString = @"https://cartaperdue.it/partner/checkEmail.php";
        postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    [usr objectAtIndex:0], @"usr", nil];
    }
    else if (usr.count == 2) {
        urlString = @"https://cartaperdue.it/partner/login.php";
        postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    [usr objectAtIndex:0], @"usr",
                    [usr objectAtIndex:1], @"psw",
                    nil];
    }
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


+ (void)sendRetrievePswForUser:(NSString*)usr delegate:(id<WMHTTPAccessDelegate>)delegate {
    //NSLog(@"DBACCESS RECUPERA PASSWORD");
    
    NSString *urlString = @"http://www.cartaperdue.it/partner/recuperaPsw.php";
    
    NSDictionary *postDict =[NSDictionary dictionaryWithObjectsAndKeys:
                             usr, @"usr",
                             nil];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


+ (void)buyCouponRequest:(NSString*)string delegate:(id<WMHTTPAccessDelegate>)delegate {
    NSString *urlString = @"https://cartaperdue.it/partner/acquistoCoupon.php";
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithCapacity:10];
    NSArray *pairs = [string componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *keyValue = [pair componentsSeparatedByString:@"="];
        [postDict setObject:[keyValue objectAtIndex:1] forKey:[keyValue objectAtIndex:0]];
    }
    NSLog(@"[%@ buyCouponRequest] string = [%@], \n\tpostDict = %@", [self class], string, postDict);
    
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}

+ (void)requestACard:(NSArray*)data delegate:(id<WMHTTPAccessDelegate>)delegate {
    
    NSString *urlString = @"https://cartaperdue.it/partner/v2.0/RichiediCarta.php";
    
    
    NSDictionary *postDict =[NSDictionary dictionaryWithObjectsAndKeys:
                             [data objectAtIndex:0], @"cardType",
                             [data objectAtIndex:1], @"name",
                             [data objectAtIndex:2], @"surname",
                             [data objectAtIndex:3], @"phone",
                             [data objectAtIndex:4], @"email",
                             nil];
    
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodPOST parameters:postDict delegate:delegate];
}


+ (void)getAltreOfferteFromServer:(NSString*)prov delegate:(id<WMHTTPAccessDelegate>)delegate {
    //NSLog(@"QUERY: altre offerte");
    
    NSString *urlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/altreofferte.php?prov=%@", prov];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodGET parameters:nil delegate:delegate];
}

+ (void)getCouponFromServerWithId:(NSInteger)idCoupon delegate:(id<WMHTTPAccessDelegate>) delegate {
   // NSLog(@"QUERY PER COUPON CON ID");
    
	NSString *urlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/offerta2.php?id=%d", idCoupon];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodGET parameters:nil delegate:delegate];
}

+ (void)getCouponFromServer:(NSString*)prov delegate:(id<WMHTTPAccessDelegate>)delegate {
    //NSLog(@"QUERY PER COUPON");
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.cartaperdue.it/partner/coupon2.php?prov=%@",prov];
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodGET parameters:nil delegate:delegate];
}



*/
@end







