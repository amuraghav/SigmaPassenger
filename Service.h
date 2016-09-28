//
//  Service.h
//  Tinder
//
//  Created by Rahul Sharma on 04/12/13.
//  Copyright (c) 2013 3Embed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatientAppDelegate.h"
@interface Service : NSObject

+(NSMutableURLRequest *)parseLogin :(NSDictionary *)params;
+(NSMutableURLRequest *)parseSignUp :(NSDictionary *)params;
+(NSMutableURLRequest *)parseUploadImage :(NSDictionary *)params;


+(NSMutableURLRequest *)parseResetpassword :(NSDictionary *)params;

//+(NSMutableURLRequest *)parseLogout :(NSDictionary *)params;


@end
