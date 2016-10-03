//
//  AppConstants.m
//  privMD
//
//  Created by Surender Rathore on 22/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "AppConstants.h"

#pragma mark - Constants







NSString *const kPMDPublishStreamChannel = @"my_channel";
NSString *const kPMDPubNubPublisherKey   = @"pub-c-9f491335-1e5b-4a4e-b96a-29044a72447b";
NSString *const kPMDPubNubSubcriptionKey = @"sub-c-a0c4236e-3f0a-11e6-9236-02ee2ddab7fe";
NSString *const kPMDGoogleMapsAPIKey     = @"AIzaSyDDWdKKY1kqf3AllJ1oHJ0IYn3qUgHV_GQ";
NSString *const kPMDFlurryId             = @"57BYHYWWK79BJ7F8VF7J";
NSString *const kPMDTestDeviceidKey      = @"C2A33350-D9CF-4A7E-8751-A36016838381";
NSString *const kPMDDeviceIdKey          = @"deviceid";
//NSString *const kPMDStripeTestKey        = @"sk_test_AHpyM7eAriaSUDUBhzCoQJkl";
NSString *const kPMDStripeTestKey        = @"pk_test_k2C1WZf9WTRXxF9GMIjtm97c";
NSString *const kPMDStripeLiveKey        = @"pk_live_17EvZXzuKbZgnTkB0vDPaVCZ";

#pragma mark - mark URLs

// webService_1.php/


#define BASE_IP  @"http://auscartaxiapp.onsisdev.info/"



NSString *BASE_URL                           = BASE_IP @"newLogic.php/";
NSString *BASE_URL_UPLOADIMAGE               = BASE_IP @"newLogic.php/uploadImage";
NSString *const   baseUrlForXXHDPIImage      = BASE_IP @"pics/xxhdpi/";
NSString *const   baseUrlForOriginalImage    = BASE_IP @"pics/";
#pragma mark - ServiceMethods
// eg : prifix kSM≈
NSString *const kSMLiveBooking                = @"liveBooking";
NSString *const kSMGetAppointmentDetial       = @"getAppointmentDetails";
NSString *const kSMUpdateSlaveReview          = @"updateSlaveReview";
NSString *const kSMGetMasters                 = @"getMasters";
NSString *const kSMCancelAppointment          = @"cancelAppointment";
NSString *const kSMCancelOngoingAppointment   = @"cancelAppointmentRequest";


NSString *const kSMLiveBookingPopLock           = @"popuplockBooking";

//New Api for Later booking
NSString *const kSMLaterBooking                = @"laterBooking";

//Methods
NSString *MethodPatientSignUp                = @"slaveSignup";
NSString *MethodPatientLogin                 = @"slaveLogin";
NSString *MethodDoctorUploadImage            = @"uploadImage";
NSString *MethodPassengerLogout              = @"logout";
NSString *MethodFareCalculator               = @"fareCalculator";
NSString *MethodServiceEstimate              = @"getserviceestimate";


NSString *MethodchangePassword               = @"changePassword";


// Promo Code :: prifix kSM New Add

NSString *const kSMAddPromoCode   = @"checkPromocode";

//SignUp

NSString *KDASignUpFirstName                  = @"ent_first_name";
NSString *KDASignUpLastName                   = @"ent_last_name";
NSString *KDASignUpMobile                     = @"ent_mobile";
NSString *KDASignUpEmail                      = @"ent_email";
NSString *KDASignUpPassword                   = @"ent_password";
NSString *KDASignUpAddLine1                   = @"ent_address_line1";
NSString *KDASignUpAddLine2                   = @"ent_address_line2";
NSString *KDASignUpAccessToken                = @"ent_token";
NSString *KDASignUpDateTime                   = @"ent_date_time";
NSString *KDASignUpCountry                    = @"ent_country";
NSString *KDASignUpCity                       = @"ent_city";
NSString *KDASignUpDeviceType                 = @"ent_device_type";
NSString *KDASignUpDeviceId                   = @"ent_dev_id";
NSString *KDASignUpPushToken                  = @"ent_push_token";
NSString *KDASignUpZipCode                    = @"ent_zipcode";
NSString *KDASignUpCreditCardNo               = @"ent_cc_num";
NSString *KDASignUpCreditCardCVV              = @"ent_cc_cvv";
NSString *KDASignUpCreditCardExpiry           = @"ent_cc_exp";
NSString *KDASignUpTandC                      = @"ent_terms_cond";
NSString *KDASignUpPricing                    = @"ent_pricing_cond";
NSString *KDASignUpLatitude                   = @"ent_latitude";
NSString *KDASignUpLongitude                  = @"ent_longitude";

//Add new
NSString *KDASignUpOTP                  = @"ent_otp";

// Login

NSString *KDALoginEmail                       = @"ent_email";
NSString *KDALoginPassword                    = @"ent_password";
NSString *KDALoginDeviceType                  = @"ent_device_type";
NSString *KDALoginDevideId                    = @"ent_dev_id";
NSString *KDALoginPushToken                   = @"ent_push_token";
NSString *KDALoginUpDateTime                  =@"ent_date_time";

//TODO :: Fb login add new params

NSString *KDALoginfName                   = @"ent_first_name";
NSString *KDALoginlName                   = @"ent_last_name";
NSString *KDALoginPicture                 = @"ent_profile_pic";
NSString *KDALoginType                    = @"ent_login_type";


//Reset Password

NSString *KDAoldPassword        = @"ent_old_password";
NSString *KDAnewPassword        = @"ent_password";
NSString *KDAUserType           = @"ent_user_type";
NSString *KDASeesionToken       = @"ent_sess_token";
NSString *KDAResetpswDevideId   = @"ent_dev_id";


//Upload
//Upload
NSString *KDAUploadDeviceId                    = @"ent_dev_id";
NSString *KDAUploadSessionToken                = @"ent_sess_token";
NSString *KDAUploadImageName                   = @"ent_snap_name";
NSString *KDAUploadImageChunck                 = @"ent_snap_chunk";
NSString *KDAUploadfrom                        = @"ent_upld_from";
NSString *KDAUploadtype                        = @"ent_snap_type";
NSString *KDAUploadDateTime                    = @"ent_date_time";
NSString *KDAUploadOffset                      = @"ent_offset";

// Logout the user

NSString *KDALogoutSessionToken                = @"user_session_token";
NSString *KDALogoutUserId                      = @"logout_user_id";



//Parsms for checking user loged out or not

NSString *KDAcheckUserId                        = @"user_id";
NSString *KDAcheckUserSessionToken              = @"ent_sess_token";
NSString *KDAgetPushToken                       = @"ent_push_token";

//Params to store the Country & City.

NSString *KDACountry                            = @"country";
NSString *KDACity                               = @"city";
NSString *KDALatitude                           = @"latitudeQR";
NSString *KDALongitude                          = @"longitudeQR";

//params for Firstname
NSString *KDAFirstName                          = @"ent_first_name";
NSString *KDALastName                           = @"ent_last_name";
NSString *KDAEmail                              = @"ent_email";
NSString *KDAPhoneNo                            = @"ent_mobile";
NSString *KDAPassword                           = @"ent_password";

#pragma mark - NSUserDeafults Keys
NSString *const kNSUPatientPubNubChannelkey           = @"pChannel";
NSString *const kNSUAppoinmentDoctorDetialKey         = @"doctorDetial";
NSString *const kNSUPatientEmailAddressKey            = @"pEmail";
NSString *const kNSUMongoDataBaseAPIKey               = @"mongoDBapi";
NSString *const kNSUIsPassengerBookedKey              = @"passengerBooked";
NSString *const kNSUPassengerBookingStatusKey         = @"STATUSKEY";
NSString *const KUBERCarArrayKey                      = @"carTypeArray";

#pragma mark - PushNotification Payload Keys

 NSString *const kPNPayloadDoctorNameKey            = @"n";
 NSString *const kPNPayloadAppoinmentTimeKey        = @"dt";
 NSString *const kPNPayloadDistanceKey              = @"dis";
 NSString *const kPNPayloadEstimatedTimeKey         = @"eta";
 NSString *const kPNPayloadDoctorEmailKey           = @"e";
 NSString *const kPNPayloadDoctorContactNumberKey   = @"ph";
 NSString *const kPNPayloadProfilePictureUrlKey     = @"pic";
NSString *const  kPNPayloadStatusIDKey              = @"nt";
NSString *const  kPNPayloadAppointmentIDKey         = @"id";

#pragma mark - Car DescriptionKeys
NSString *const KUBERCarTypeID               = @"type_id";
NSString *const KUBERCarTypeName             = @"type_name";
NSString *const KUBERCarMaxSize              = @"max_size";
NSString *const KUBERCarBaseFare             = @"basefare";
NSString *const KUBERCarMinFare              = @"min_fare";
NSString *const KUBERCarPricePerMin          = @"price_per_min";
NSString *const KUBERCarPricePerKM           = @"price_per_km";
NSString *const KUBERCarTypeDescription      = @"type_desc";
NSString *const KUBERDriverStatus            = @"status";


#pragma mark - Notification Name keys
NSString *const kNotificationNewCardAddedNameKey   = @"cardAdded";
NSString *const kNotificationCardDeletedNameKey   = @"cardDeleted";
NSString *const kNotificationLocationServicesChangedNameKey = @"CLChanged";
NSString *const kNotificationBookingConfirmationNameKey = @"bookingConfirmed";

#pragma mark - Network Error
NSString *const kNetworkErrormessage          = @"No network connection";

NSString *const KNUCurrentLat          = @"latitude";
NSString *const KNUCurrentLong         = @"longitude";
NSString *const KNUserCurrentCity      = @"usercity";
NSString *const KNUserCurrentState     = @"userstate";
NSString *const KNUserCurrentCountry   = @"userCountry";

NSString *const KUDriverEmail           = @"DriverEmail";
NSString *const KUBookingDate           = @"BookingDate";
NSString *const KUBookingID             = @"BookingID";
