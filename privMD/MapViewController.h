//
//  MapViewController.h
//  DoctorMapModule
//
//  Created by Rahul Sharma on 03/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "WildcardGestureRecognizer.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "MyAppTimerClass.h"

typedef enum {
    isBookingDetailsServieCalled = 0,
    isBookingDetailsViewShown = 1
}BookingStatus;

@interface MapViewController : UIViewController<GMSMapViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate , UIGestureRecognizerDelegate, UINavigationControllerDelegate>
{
    BOOL isCarType1Selected;
    BOOL isCarType2Selected;
    BOOL isCarType3Selected;
    BOOL isCarType4Selected;
    
    BOOL isNurseSelected;
    BOOL isLaterSelected;
    BOOL isNowSelected;
    BOOL isCustomMarkerSelected;
    BOOL isFareButtonClicked;
    BOOL isRequestingButtonClicked;
    
    BOOL isPopLockSelected;
    
    PatientAppDelegate *appDelegate;
    NSMutableArray		*arrDBResult;
	NSManagedObjectContext *context;
    
    UIDatePicker *datePicker;
    UIActionSheet *newSheet;
    
    MFMailComposeViewController *mailer;
    
    UIView *mainView;
    
    
      // BOOL isTnCButtonSelected;
    
    UIView *viewCarTypes;
    
    UIPickerView *_pickerView;
    UIToolbar *_toolBar;
    NSMutableArray *arrayMaximumNumberOfPayee;
    UIToolbar *_keyboardToolbar;
    
    UITextField *txtfCarTypes;
    UITextField *txtftime;

    UILabel *lbl4;
    UILabel *lbl5;
    UILabel *lbl6;
    
    UILabel *lblBaseFare;
    UILabel *lblDistance;
    UILabel *lblVehicleName;
    
    UILabel *lblCarType;
    
    NSString *strSaveLastCarName;
    
    //add new bool for change location
    BOOL _IscurrentLocation;
    
    
    //add user name and pasword
      UITextField *txtName;
      UITextField *txtPhone;
    
    
      NSString *promocode_id;
    
    
    
    NSString *strDistance;
    

}
@property(nonatomic,strong) UIPickerView *pkrView;

@property (strong, nonatomic) NSMutableArray *doctors ;
@property (strong, nonatomic) NSArray *nurses ;
@property (strong, nonatomic) NSArray *buttonArray ;
@property (strong, nonatomic) NSArray *buttonArray2 ;
@property (strong, nonatomic) NSDictionary *dictSelectedDoctor;
@property (strong, nonatomic) UITextField *textFeildAddress;
@property (assign, nonatomic) CarSpecialistType carType;
@property (assign, nonatomic) BookingStatus bookingStatus;
@property MyAppTimerClass *myAppTimerClassObj;

- (IBAction)pickupLocationAction:(UIButton *)sender;

+ (instancetype) getSharedInstance;
-(void)publishPubNubStream;
-(void)hideActivityIndicatorWithMessage;
- (void) sendRequestgetETAnDistance;

@end
