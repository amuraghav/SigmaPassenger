//
//  AppointedDoctor.m
//  privMD
//
//  Created by Surender Rathore on 26/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "AppointedDoctor.h"

@implementation AppointedDoctor
@synthesize driverName;
@synthesize appoinmentDate;
@synthesize contactNumber;
@synthesize profilePicURL;
@synthesize distance;
@synthesize estimatedTime;
@synthesize email;
@synthesize status;
@synthesize appTdateForPresentAppt;
@synthesize statusID,appointmentID;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.driverName = [aDecoder decodeObjectForKey:@"driverName"];
        self.appoinmentDate = [aDecoder decodeObjectForKey:@"appoinmentDate"];
        self.contactNumber = [aDecoder decodeObjectForKey:@"contactNumber"];
        self.profilePicURL = [aDecoder decodeObjectForKey:@"picUrl"];
        self.email = [aDecoder decodeObjectForKey:@"emai"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.statusID = [aDecoder decodeObjectForKey:@"statusID"];
        self.appointmentID = [aDecoder decodeObjectForKey:@"appointmentID"];
        self.appTdateForPresentAppt = [aDecoder decodeObjectForKey:@"apptDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:driverName forKey:@"driverName"];
    [aCoder encodeObject:appoinmentDate forKey:@"appoinmentDate"];
    [aCoder encodeObject:contactNumber forKey:@"contactNumber"];
    [aCoder encodeObject:profilePicURL forKey:@"picUrl"];
    [aCoder encodeObject:email forKey:@"emai"];
    [aCoder encodeObject:status forKey:@"status"];
    [aCoder encodeObject:statusID forKey:@"statusID"];
    [aCoder encodeObject:appointmentID forKey:@"appointmentID"];
    [aCoder encodeObject:appTdateForPresentAppt forKey:@"apptDate"];
    
}


@end
