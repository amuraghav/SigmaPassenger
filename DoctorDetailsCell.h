//
//  DoctorDetailsCell.h
//  DoctorMapModule
//
//  Created by Rahul Sharma on 10/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedImageView.h"


@interface DoctorDetailsCell : UITableViewCell

@property (nonatomic,strong) RoundedImageView *imageProfilePic;

@property(strong, nonatomic) UILabel *labelName;
@property(strong, nonatomic) UILabel *label;
@property(strong, nonatomic) UILabel *labelSpecialities;
@property(strong, nonatomic) UILabel *labelAbout;
@property(strong, nonatomic) UILabel *labelEducation;
@property(strong, nonatomic) UILabel *labelReview;
@property(strong, nonatomic) UILabel *labelReviewBy;
@property(strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end
