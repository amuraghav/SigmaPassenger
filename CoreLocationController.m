//
//  CoreLocationController.m
//  CoreLocationDemo
//
//  Created by Nicholas Vellios on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CoreLocationController.h"


@implementation CoreLocationController

@synthesize locManager, delegate;

- (id)init
{
	self = [super init];
	
	if(self != nil)
    {
		self.locManager = [[CLLocationManager alloc] init];
		self.locManager.delegate = self;
		[locManager setDesiredAccuracy:kCLLocationAccuracyBest];
	}
	
	return self;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)])
    {
		[self.delegate locationUpdate:newLocation];
		
	}
}

//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
//		[self.delegate locationError:error];
//	}
//}


//- (void)dealloc {
//	[self.locMgr release];
//	[super dealloc];
//}

@end
