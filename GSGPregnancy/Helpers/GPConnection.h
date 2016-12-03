//
//  GPConnection.h
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/1/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GPInternetConnectionManager [GPConnection connectionMananger]

@interface GPConnection : NSObject

@property (strong, nonatomic) NSString *serverHost;

+ (instancetype)connectionMananger;
+(BOOL)checkNetworkStatus;

- (NSData*) getDataFrom:(NSString*)webService withParameters:(NSString*)params;
- (NSString *) getDataFrom:(NSString *)url withBody:(NSData *)body;
-(NSDictionary*)convertJsonToDictionary:(NSData*)json;

@end
