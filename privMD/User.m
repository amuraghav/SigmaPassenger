//
//  User.m
//  privMD
//
//  Created by Surender Rathore on 19/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "User.h"
#import "Database.h"
#import "PMDReachabilityWrapper.h"
#import "NetworkHandler.h"

#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <QuartzCore/QuartzCore.h>


@implementation User
@synthesize delegate;
- (void)logout
{
   
    [[GPPSignIn sharedInstance] signOut];
    [[GPPSignIn sharedInstance] disconnect];
    
    [[FBSession activeSession] closeAndClearTokenInformation];
   
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    int usertype = 2;
    
    NSString *strType = [NSString stringWithFormat:@"%d",usertype];
    NSString *sesstionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    NSString *date = [Helper getCurrentDateTime];
    
  
    NSDictionary *params = @{@"ent_sess_token": sesstionToken,
                             @"ent_dev_id": deviceId,
                             @"ent_user_type":strType,
                             @"ent_date_time":date ,
                             };
    
    
    
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
    if ( [reachability isNetworkAvailable]) {
        
        NetworkHandler *networHandler = [NetworkHandler sharedInstance];
        [networHandler composeRequestWithMethod:MethodPassengerLogout
                                        paramas:params
                                   onComplition:^(BOOL success, NSDictionary *response){
                                       
                                       if (success) { //handle success response
                                           [self userLogoutResponse:response];
                                       }
                                   }];
    }
    else {
       // ProgressIndicator *pi = [ProgressIndicator sharedInstance];
       // [pi showMessage:kNetworkErrormessage On:self.view];
        [Helper showAlertWithTitle:@"Message" Message:@"No Network"];
    }
    
}



- (void) userLogoutResponse:(NSDictionary *)response
{
    TELogInfo(@"response:%@",response);
    if (!response)
    {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([response objectForKey:@"Error"])
    {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
    }
    else
    {
        
        [self deleteUserSavedData];
        
        NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0) // invalid Session
        {
            
            if (delegate && [delegate respondsToSelector:@selector(userDidFailedToLogout:)]) {
                [delegate userDidFailedToLogout:nil];
            }
            
        }
        else if ([[dictResponse objectForKey:@"errFlag"] intValue] == 1)
        {
            if (delegate && [delegate respondsToSelector:@selector(userDidLogoutSucessfully:)]) {
                [delegate userDidLogoutSucessfully:YES];
            }
            
        }
        else
        {
            [Helper showAlertWithTitle:@"Error" Message:[dictResponse objectForKey:@"errMsg"]];
            
        }
    }
}
-(void)deleteUserSavedData{
    
    //delete all saved cards
    [Database DeleteAllCard];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KDAcheckUserSessionToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUBERCarArrayKey];
     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"BOOKINGID"];
//    [ud removeObjectForKey:kNSUPassengerBookingStatusKey];
//    [ud removeObjectForKey:@"subscribedChannel"];
//    [ud setBool:NO forKey:kNSUIsPassengerBookedKey];
//    [ud setBool:NO forKey:@"isServiceCalledOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateUserSessionToken
{
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    int usertype = 2;
    
    NSString *strType = [NSString stringWithFormat:@"%d",usertype];
    NSString *sesstionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    NSString *date = [Helper getCurrentDateTime];
    
    
    NSDictionary *params = @{@"ent_sess_token": sesstionToken,
                             @"ent_dev_id": deviceId,
                             @"ent_user_type":strType ,
                             @"ent_date_time":date ,
                             };
    
    PMDReachabilityWrapper *reachability = [PMDReachabilityWrapper sharedInstance];
    if ( [reachability isNetworkAvailable]) {
        
        NetworkHandler *networHandler = [NetworkHandler sharedInstance];
        [networHandler composeRequestWithMethod:@"updateSession"
                                        paramas:params
                                   onComplition:^(BOOL success, NSDictionary *response){
                                       
                                       if (success) { //handle success response
                                           [self updateSessionTokenResponse:response];
                                       }
                                   }];
    }
    
}

-(void)updateSessionTokenResponse:(NSDictionary *)response {
    
    if (!response)
    {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([response objectForKey:@"Error"])
    {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
        
    }
    else
    {
        NSDictionary *dictResponse=[response mutableCopy];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0 && [[dictResponse objectForKey:@"errNum"] intValue] == 73)
        {
            if (delegate && [delegate respondsToSelector:@selector(userDidUpdateSessionSucessfully:)]) {
                [delegate userDidUpdateSessionSucessfully:YES];
            }
        }
        else if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0 && [[dictResponse objectForKey:@"errNum"] intValue] == 89)
        {
            [[NSUserDefaults standardUserDefaults]setObject:[response objectForKey:@"token"] forKey:KDAcheckUserSessionToken];;
            [[NSUserDefaults standardUserDefaults]synchronize];
            if (delegate && [delegate respondsToSelector:@selector(userDidUpdateSessionSucessfully:)]) {
                [delegate userDidUpdateSessionSucessfully:YES];
            }
            
        }
        else if ([[dictResponse objectForKey:@"errFlag"] intValue] == 1)
        {
            if (delegate && [delegate respondsToSelector:@selector(userDidUpdateSessionUnSucessfully:)]) {
                [delegate userDidUpdateSessionUnSucessfully:NO];
            }
            
        }
        else
        {
            
        }
    }
}



@end
