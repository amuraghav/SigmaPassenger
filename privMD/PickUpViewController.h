//
//  PickUpViewController.h
//  DoctorMapModule
//
//  Created by Rahul Sharma on 04/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickUpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    PatientAppDelegate *appDelegate;
    NSMutableArray		*arrDBResult;
	NSManagedObjectContext *context;
}
@property(nonatomic,assign) BOOL isComingFromMapVCFareButton;

@property (nonatomic, copy)   void (^onCompletion)(NSDictionary *suburb,NSInteger locationtype);
@property(strong, nonatomic)  NSString *searchString;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarController;
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *mAddress;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (assign, nonatomic) NSInteger locationType;
- (IBAction)dismissViewController:(UIButton *)sender;

@property (assign, nonatomic) NSInteger carTypesForLiveBookingServer;


@end
