//
//  MyAppTimerClass.m
//  UBER
//
//  Created by Rahul Sharma on 30/08/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//


#import "MyAppTimerClass.h"
#import "MapViewController.h"

static MyAppTimerClass *myAppTimer =nil;
@implementation MyAppTimerClass

@synthesize pubnubStreamTimer,spinTimer,etanDisTimer;

+ (id)sharedInstance {
    
    if (!myAppTimer) {
        myAppTimer = [[self alloc]init];
       
    }
     return myAppTimer;
}

-(void)startPublishTimer {
    
    if (self.pubnubStreamTimer == nil)
    {
        pubnubStreamTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(publishPubNubStream:) userInfo:nil repeats:YES];

    }
    
}
-(void)stopPublishTimer {
    
    if ([self.pubnubStreamTimer isValid]) {
        [self.pubnubStreamTimer invalidate];
    }
    
}
-(void)publishPubNubStream:(NSTimer *)myTimer {
    
    MapViewController *obj = [MapViewController getSharedInstance];
    if(obj)
    {
        [obj publishPubNubStream];
    }
}

-(void)startEtaNDisTimer {
    
    if (self.etanDisTimer == nil)
    {
        etanDisTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(sendEtanDis:) userInfo:nil repeats:YES];
        
    }
    
}
-(void)stopEtaNDisTimer  {
    
    if ([self.etanDisTimer isValid]) {
        [self.etanDisTimer invalidate];
    }
    
}

-(void)sendEtanDis:(NSTimer *)myTimer {
    
    MapViewController *obj = [MapViewController getSharedInstance];
    if(obj)
    {
        [obj sendRequestgetETAnDistance];
    }
}

-(void)startSpinTimer {
    
    if (self.spinTimer == nil)
    {
        spinTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(hideActivityIndicator:) userInfo:nil repeats:NO];
        
    }
    
}

-(void)stopSpinTimer {
    
    if ([self.spinTimer isValid]) {
        [self.spinTimer invalidate];
    }
    
}

-(void)hideActivityIndicator:(NSTimer *)myTimer {
    
    MapViewController *obj = [MapViewController getSharedInstance];
    if(obj)
    {
        [obj hideActivityIndicatorWithMessage];
    }
}

@end
