//
//  GPConnection.m
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/1/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//



@import Foundation;
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "GPConnection.h"


@implementation GPConnection {
    
}

@synthesize serverHost;

+ (BOOL)checkNetworkStatus
{
    
    return Reachability.reachabilityForInternetConnection.isReachable;
}

+ (instancetype)connectionMananger
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
    if (self) {
        self.serverHost = @"http://45.55.80.106:1212/";
    }
    return self;
}

- (NSData*) getDataFrom:(NSString*)webService withParameters:(NSString*)params{
    
    NSString* url;
    
    if ([params isEqualToString:@""]) {
        url = [NSString stringWithFormat:@"http://45.55.80.106:1212/%@",webService];
    }
    else
    {
        url = [NSString stringWithFormat:@"http://45.55.80.106:1212/%@?%@",webService,params];
    }
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
    
    return oResponseData;
    //    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}


- (NSString *) getDataFrom:(NSString *)url withBody:(NSData *)body{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url,[responseCode statusCode]);
        return nil;
    }
    
    return oResponseData;
}


-(NSDictionary*)convertJsonToDictionary:(NSData*)json
{
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:&error];
    
    return dic;
}

@end
