//
//  AppointmentLocation.h
//  privMD
//
//  Created by Surender Rathore on 11/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointmentLocation : NSObject
+ (id)sharedInstance;
@property(nonatomic,strong)NSNumber *currentLatitude;
@property(nonatomic,strong)NSNumber *currentLongitude;
@property(nonatomic,strong)NSNumber *pickupLatitude;
@property(nonatomic,strong)NSNumber *pickupLongitude;
@property(nonatomic,strong)NSNumber *dropOffLatitude;
@property(nonatomic,strong)NSNumber *dropOffLongitude;

@property(nonatomic,strong)NSString *srcAddressLine1;
@property(nonatomic,strong)NSString *srcAddressLine2;
@property(nonatomic,strong)NSString *desAddressLine1;
@property(nonatomic,strong)NSString *desAddressLine2;

@end
