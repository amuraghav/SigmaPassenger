//
//  BookingDirectionViewController.h
//  privMD
//
//  Created by Surender Rathore on 26/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@interface BookingDirectionViewController : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
     MFMailComposeViewController *mailer;
}
@property(nonatomic,strong) NSTimer *pollingTimer;

@property(nonatomic,strong) NSString *appointmentDate;
@property(nonatomic,strong) NSString *apptDateForPolling;
@property(nonatomic,strong) NSString *apptid;
@property(nonatomic,strong) NSString *doctorEmail;
@property(nonatomic,strong) NSString *drivermsg;
@property(nonatomic,strong) NSDictionary *disnEta;
@end
