//
//  SourceAddress.h
//  UBER
//
//  Created by Rahul Sharma on 22/09/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SourceAddress : NSManagedObject

@property (nonatomic, retain) NSString * srcAddress;
@property (nonatomic, retain) NSString * srcAddress2;
@property (nonatomic, retain) NSNumber * srcLatitude;
@property (nonatomic, retain) NSNumber * srcLongitude;

@end
