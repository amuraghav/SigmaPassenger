//
//  User.h
//  privMD
//
//  Created by Surender Rathore on 19/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserDelegate;
@interface User : NSObject
@property(nonatomic,weak)id <UserDelegate> delegate;
-(void)logout;
- (void)updateUserSessionToken;

@end

@protocol UserDelegate <NSObject>

@optional

-(void)userDidLogoutSucessfully:(BOOL)sucess;
-(void)userDidFailedToLogout:(NSError*)error;
-(void)userDidUpdateSessionSucessfully:(BOOL)sucess;
-(void)userDidUpdateSessionUnSucessfully:(BOOL)sucess;

@end