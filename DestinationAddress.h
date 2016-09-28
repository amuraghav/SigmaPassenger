//
//  DestinationAddress.h
//  UBER
//
//  Created by Rahul Sharma on 22/09/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DestinationAddress : NSManagedObject

@property (nonatomic, retain) NSString * desAddress;
@property (nonatomic, retain) NSString * desAddress2;
@property (nonatomic, retain) NSNumber * desLatitude;
@property (nonatomic, retain) NSNumber * desLongitude;

@end
