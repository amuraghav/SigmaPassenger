//
//  MyAppTimerClass.h
//  UBER
//
//  Created by Rahul Sharma on 30/08/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAppTimerClass : NSObject

@property(nonatomic,weak) NSTimer *pubnubStreamTimer;
@property(nonatomic,weak) NSTimer *etanDisTimer;
@property(nonatomic,weak) NSTimer *spinTimer;

+ (id)sharedInstance;

-(void)startPublishTimer;

-(void)stopPublishTimer;

-(void)startSpinTimer;

-(void)stopSpinTimer;

-(void)startEtaNDisTimer;

-(void)stopEtaNDisTimer;

@end
