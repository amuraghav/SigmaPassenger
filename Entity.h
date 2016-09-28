//
//  Entity.h
//  privMD
//
//  Created by Rahul Sharma on 20/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * expMonth;
@property (nonatomic, retain) NSString * expYear;
@property (nonatomic, retain) NSString * idCard;
@property (nonatomic, retain) NSString * last4;
@property (nonatomic, retain) NSString * cardtype;

@end
