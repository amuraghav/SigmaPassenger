//
//  PatientAppDelegate.h
//  privMD
//
//  Created by Rahul Sharma on 11/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>

@interface PatientAppDelegate : UIResponder <UIApplicationDelegate>



@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (nonatomic,assign) BOOL _IsSwitchOn;
@property (nonatomic,assign) BOOL  IscalenderscrollBool;

//TODO :: Create propperty for payment type.
@property (strong, nonatomic) NSString *paymentTypevalue ;
@property (nonatomic,assign) BOOL _IsShowPaymentMODE;
//.............................
@property (nonatomic,assign) BOOL _IsShowMainView;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)noPushForceChangingController:(NSDictionary *)userInfo :(int)type;
@property (assign, nonatomic) CancelBookingReasons cancelReason;

-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;






@end
