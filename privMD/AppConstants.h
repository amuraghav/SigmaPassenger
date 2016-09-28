//
//  AppConstants.h
//  privMD
//
//  Created by Surender Rathore on 22/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//




#pragma mark - enums

typedef enum {
    
    kNotificationTypeBookingOnMyWay = 6,
    kNotificationTypeBookingReachedLocation = 7,
    kNotificationTypeBookingStarted = 8,
    kNotificationTypeBookingComplete = 9,
    kNotificationTypeBookingReject = 10,
    kNotificationTypeBookingAccept = 21,
    kNotificationTypeBookingLaterReject = 22

}BookingNotificationType;
typedef enum {
    
    kCBRPassengerDoNotShow = 4,
    kCBRWrongAddressShown = 5,
    kCBRDPassengerRequestedCancel = 6,
    kCBRDoNotChargeClient = 7,
    kCBOhterReasons = 8,
    
}CancelBookingReasons;

typedef enum {
    kPubNubStartStreamAction = 1,
    kPubNubStopStreamAction = 2,
    kPubNubUpdatePatientAppointmentLocationAction = 3,
    kPubNubStartDoctorLocationStreamAction = 5,
    kPubNubStopDoctorLocationStreamAction  = 6
}PubNubStreamAction;


typedef enum {
    kAppointmentTypeNow = 3,
    kAppointmentTypeLater = 4
}AppointmentType;

typedef enum {
    kRoadyoCarOne = 1,
    kRoadyoCarTwo = 2,
    kRoadyoCarThree = 3,
    kRoadyoCarFour = 4
}CarSpecialistType;

#pragma mark - Constants
//eg: give prifix kPMD

extern NSString *const kPMDPublishStreamChannel;
extern NSString *const kPMDPubNubPublisherKey;
extern NSString *const kPMDPubNubSubcriptionKey;
extern NSString *const kPMDGoogleMapsAPIKey;
extern NSString *const kPMDFlurryId;
extern NSString *const kPMDTestDeviceidKey;
extern NSString *const kPMDDeviceIdKey;
extern NSString *const KUBERCarArrayKey;
extern NSString *const kPMDStripeTestKey;
extern NSString *const kPMDStripeLiveKey;

//Eg for CarTypes prifix KUBERCarTypeID
extern NSString *const KUBERCarTypeID;
extern NSString *const KUBERCarTypeName;
extern NSString *const KUBERCarMaxSize;
extern NSString *const KUBERCarBaseFare;
extern NSString *const KUBERCarMinFare;
extern NSString *const KUBERCarPricePerMin;
extern NSString *const KUBERCarPricePerKM;
extern NSString *const KUBERCarTypeDescription;
extern NSString *const KUBERDriverStatus;

#pragma mark - mark URLs

//Base URL

extern NSString *BASE_URL;
extern NSString *BASE_URL_UPLOADIMAGE;
extern NSString *const   baseUrlForXXHDPIImage;
extern NSString *const   baseUrlForOriginalImage;
//Methods
extern NSString *MethodPatientSignUp;
extern NSString *MethodPatientLogin;
extern NSString *MethodDoctorUploadImage;
extern NSString *MethodPassengerLogout;
extern NSString *MethodFareCalculator;

extern NSString *MethodchangePassword;



#pragma mark - ServiceMethods
// eg : prifix kSM
extern NSString *const kSMLiveBooking;
extern NSString *const kSMGetAppointmentDetial;
extern NSString *const kSMCancelAppointment;
extern NSString *const kSMCancelOngoingAppointment;
extern NSString *const kSMUpdateSlaveReview;
extern NSString *const kSMGetMasters ;

extern NSString *const kSMLiveBookingPopLock;

//Add new Api for later booking
extern NSString *const kSMLaterBooking;


// add new for Promo code

extern NSString *const kSMAddPromoCode;

//Request Params For SignUp
extern NSString *KDASignUpFirstName;
extern NSString *KDASignUpLastName;
extern NSString *KDASignUpMobile;
extern NSString *KDASignUpEmail;
extern NSString *KDASignUpPassword;
extern NSString *KDASignUpCountry;
extern NSString *KDASignUpCity;
extern NSString *KDASignUpDeviceType;
extern NSString *KDASignUpDeviceId;
extern NSString *KDASignUpAddLine1;
extern NSString *KDASignUpAddLine2;
extern NSString *KDASignUpPushToken;
extern NSString *KDASignUpZipCode;
extern NSString *KDASignUpAccessToken;
extern NSString *KDASignUpDateTime;
extern NSString *KDASignUpCreditCardNo;
extern NSString *KDASignUpCreditCardCVV;
extern NSString *KDASignUpCreditCardExpiry;
extern NSString *KDASignUpTandC;
extern NSString *KDASignUpPricing;
extern NSString *KDASignUpLatitude;
extern NSString *KDASignUpLongitude;
//Add new for OTP
extern NSString *KDASignUpOTP;




//Request Params For Login

extern NSString *KDALoginEmail;
extern NSString *KDALoginPassword;
extern NSString *KDALoginDeviceType;
extern NSString *KDALoginDevideId;
extern NSString *KDALoginPushToken;
extern NSString *KDALoginUpDateTime;

// ToDO  :: Add new params for FB Login
extern NSString *KDALoginfName;
extern NSString *KDALoginlName;
extern NSString *KDALoginPicture;
extern NSString *KDALoginType;

//reset password
extern NSString *KDAoldPassword ;
extern NSString *KDAnewPassword ;
extern NSString *KDAUserType  ;
extern NSString *KDASeesionToken ;
extern NSString *KDAResetpswDevideId ;


//Request for Upload Image
extern NSString *KDAUploadDeviceId;
extern NSString *KDAUploadSessionToken;
extern NSString *KDAUploadImageName;
extern NSString *KDAUploadImageChunck;
extern NSString *KDAUploadfrom;
extern NSString *KDAUploadtype;
extern NSString *KDAUploadDateTime;
extern NSString *KDAUploadOffset;

//Request Params For Logout the user

extern NSString *KDALogoutSessionToken;
extern NSString *KDALogoutUserId;
extern NSString *KDALogoutDateTime;

//Parsms for checking user loged out or not

extern NSString *KDAcheckUserLogedOut;
extern NSString *KDAcheckUserSessionToken;
extern NSString *KDAgetPushToken;

//Params to store the Country & City.

extern NSString *KDACountry;
extern NSString *KDACity;
extern NSString *KDALatitude;
extern NSString *KDALongitude;

//params for firstname
extern NSString *KDAFirstName;
extern NSString *KDALastName;
extern NSString *KDAEmail;
extern NSString *KDAPhoneNo;
extern NSString *KDAPassword;




#pragma mark - NSUserDeafults Keys
//eg : give prefix kNSU

extern NSString *const kNSUPatientPubNubChannelkey;
extern NSString *const kNSUAppoinmentDoctorDetialKey;
extern NSString *const kNSUPatientEmailAddressKey;
extern NSString *const kNSUMongoDataBaseAPIKey;
extern NSString *const kNSUIsPassengerBookedKey;
extern NSString *const kNSUPassengerBookingStatusKey;

#pragma mark - PushNotification Payload Keys
//eg : give prefix kPN
extern NSString *const kPNPayloadDoctorNameKey;
extern NSString *const kPNPayloadAppoinmentTimeKey;
extern NSString *const kPNPayloadDistanceKey;
extern NSString *const kPNPayloadEstimatedTimeKey;
extern NSString *const kPNPayloadDoctorEmailKey;
extern NSString *const kPNPayloadDoctorContactNumberKey;
extern NSString *const kPNPayloadProfilePictureUrlKey;
extern NSString *const kPNPayloadStatusIDKey;
extern NSString *const kPNPayloadAppointmentIDKey;
extern NSString *const kPNPayloadStatusIDKey;



#pragma mark - Controller Keys

#pragma mark - Notification Name keys
extern NSString *const kNotificationNewCardAddedNameKey;
extern NSString *const kNotificationCardDeletedNameKey;
extern NSString *const kNotificationLocationServicesChangedNameKey;
extern NSString *const kNotificationBookingConfirmationNameKey;
#pragma mark - Network Error
extern NSString *const kNetworkErrormessage;

extern NSString *const KNUCurrentLat;
extern NSString *const KNUCurrentLong;
extern NSString *const KNUserCurrentCity;
extern NSString *const KNUserCurrentState;
extern NSString *const KNUserCurrentCountry;

extern NSString *const KUDriverEmail;
extern NSString *const KUBookingDate;
extern NSString *const KUBookingID;


