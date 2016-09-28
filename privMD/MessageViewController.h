//
//  MessageViewController.h
//  UBER
//
//  Created by Rahul Sharma on 30/09/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController<UITextViewDelegate>
@property (strong,nonatomic) NSString *driverMobileNumber;
@end
