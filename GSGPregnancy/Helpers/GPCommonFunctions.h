//
//  GPCommonFunctions.h
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/1/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import <Foundation/Foundation.h>


@class UINavigationController;

#define GPSharedInstance [GPCommonFunctions sharedInstance]

@interface GPCommonFunctions : NSObject

@property NSString* userID;

-(UINavigationController *)navigationController;
- (NSString *) getDataFrom:(NSString *)webService withParameters:(NSString*)params;

+(instancetype)sharedInstance;
+(NSString*)filterNullString:(NSString*)string;
+(NSString*)formatDate:(NSDate *)date;
+(NSString*)formatDateWS:(NSString *)dateStr;

@end
