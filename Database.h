//
//  Database.h
//  privMD
//
//  Created by Rahul Sharma on 20/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject

+ (NSArray *)getCardDetails;
- (void)makeDataBaseEntry:(NSDictionary *)dictionary;
+ (BOOL)DeleteCard:(NSString*)Campaign_id;
+ (void)DeleteAllCard;

//SourceAddress
-(void)addSourceAddressInDataBase:(NSDictionary *)dictionary;
+(NSArray *)getSourceAddressFromDataBase;
+ (void)deleteAllSourceAddress;

//Destination Address
-(void)addDestinationAddressInDataBase:(NSDictionary *)dictionary;
+(NSArray *)getDestinationAddressFromDataBase;
+ (void)deleteAllDestinationAddress;

@end
