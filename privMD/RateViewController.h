//
//  RateViewController.h
//  privMD
//
//  Created by Rahul Sharma on 10/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *writeLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;

@property(nonatomic,strong)NSString *appointmentDate;
@property(nonatomic,strong)NSString *appointmentid;

@property(nonatomic,strong)NSString *doctorEmail;

@property (weak, nonatomic) IBOutlet UILabel *_ratingTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewTextViewPlaceHolder;


@end
