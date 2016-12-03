//
//  GPCommonFunctions.m
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/1/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GPCommonFunctions.h"
#import "GPRegisterVC.h"
#import "GPLoginVC.h"
#import "GPHomeWithSideMenuVC.h"

@interface GPCommonFunctions () <UINavigationControllerDelegate>
@end


@implementation GPCommonFunctions
{
    UINavigationController* appRootVC;
}

@synthesize userID;

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    @synchronized(self)
    {
        if (sharedInstance == nil)
            sharedInstance = [self new];
    }
    return sharedInstance;
}



- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
        appRootVC = UINavigationController.new;
        appRootVC.delegate = self;
        appRootVC.navigationBar.translucent = YES;
        appRootVC.navigationBar.tintColor = [UIColor whiteColor];
        
//        [appRootVC setViewControllers:@[GPLoginVC.new] animated:YES];
        
    }
    return self;
}


-(UINavigationController*)navigationController
{
    return appRootVC;
}


- (NSString*) getDataFrom:(NSString*)webService withParameters:(NSString*)params{
    
    NSString* url = [NSString stringWithFormat:@"http://apparplusit.com/pregnancyApp/rest/%@.php/%@",webService,params];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url,[responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

+(NSString*)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

+(NSString*)formatDateWS:(NSString *)dateStr
{
    
    
    if (dateStr == nil || [dateStr isEqualToString:@""]) {
        
        return @"";
        
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM'/'dd'/'yyyy"];
    
    
    NSDate *date = [formatter dateFromString:dateStr];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *outString = [formatter stringFromDate:date];
    
    return outString;}

+(NSString*)filterNullString:(NSString*)string
{
    if (string == nil || string == NULL)
        return @"";
    
    else
        return string;
}
@end
