//
//  AppointmentLocation.m
//  privMD
//
//  Created by Surender Rathore on 11/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "AppointmentLocation.h"

@implementation AppointmentLocation
@synthesize currentLatitude,currentLongitude;
@synthesize pickupLatitude,pickupLongitude;
@synthesize dropOffLatitude,dropOffLongitude;
@synthesize srcAddressLine1,srcAddressLine2;
@synthesize desAddressLine1,desAddressLine2;

static AppointmentLocation *appointmentLocaiton;

+ (id)sharedInstance {
	if (!appointmentLocaiton) {
		appointmentLocaiton  = [[self alloc] init];
	}
	
	return appointmentLocaiton;
}

@end
