//
//  DoctorDetailsCell.m
//  DoctorMapModule
//
//  Created by Rahul Sharma on 10/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "DoctorDetailsCell.h"
#import <Canvas/CSAnimationView.h>

@implementation DoctorDetailsCell
@synthesize imageProfilePic;
@synthesize labelName;
@synthesize label;
@synthesize labelSpecialities;
@synthesize labelAbout;
@synthesize labelEducation;
@synthesize labelReview;
@synthesize labelReviewBy;
@synthesize activityIndicator;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //Section 1
//        imageProfilePic = [[RoundedImageView alloc]initWithFrame:CGRectMake(15,10, 83, 83)];
//        [self.contentView addSubview:imageProfilePic];
//        
//        labelName = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 150, 30)];
//        [Helper setToLabel:labelName Text:@"" WithFont:ZURICH_LIGHT FSize:18 Color:[UIColor blackColor]];
//        [self.contentView addSubview:labelName];
////        
////        label = [[UILabel alloc]initWithFrame:CGRectMake(130, labelName.frame.size.height, 150, 30)];
////         [Helper setToLabel:label Text:@"" WithFont:HELVETICA_THIN FSize:14 Color:[UIColor blackColor]];
////        [self.contentView addSubview:label];
//        
//        labelSpecialities = [[UILabel alloc]initWithFrame:CGRectMake(130, labelName.frame.size.height+10,150, 30)];
//         [Helper setToLabel:labelSpecialities Text:@"" WithFont:HELVETICA_THIN FSize:15 Color:[UIColor blackColor]];
//        [self.contentView addSubview:labelSpecialities];
//        
//        activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(50-20/2, 60-20/2, 20, 20)];
//        [self.imageProfilePic addSubview:activityIndicator];
//        // activityIndicator.backgroundColor=[UIColor greenColor];
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        
//
//        
//        
//        //Section 2
//         labelAbout = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 290, 80)];
//        [Helper setToLabel:labelAbout Text:@"" WithFont:HELVETICA_THIN FSize:16 Color:UIColorFromRGB(0x666666)];
//        labelAbout.numberOfLines = 0;
//      //  labelAbout.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:labelAbout];
//        
//        //Section 3
//        labelEducation = [[UILabel alloc]initWithFrame:CGRectMake(15, 2, 290, 40)];
//        [Helper setToLabel:labelEducation Text:@"" WithFont:HELVETICA_THIN FSize:16 Color:UIColorFromRGB(0x666666)];
//        [self.contentView addSubview:labelEducation];
//        
        //Section 4
        
        labelReviewBy = [[UILabel alloc]initWithFrame:CGRectMake(15,0, 100, 20)];
        [Helper setToLabel:labelReviewBy Text:@"" WithFont:ZURICH_LIGHT_Condensed FSize:14 Color:BLACK_COLOR];
        [self.contentView addSubview:labelReviewBy];
        
        labelReview = [[UILabel alloc]initWithFrame:CGRectMake(15, labelReviewBy.frame.size.height,300, 30)];
        [Helper setToLabel:labelReview Text:@"" WithFont:HelveticaNeue_Thin FSize:13 Color:UIColorFromRGB(0x666666)];
        labelReview.numberOfLines = 0;
        [self.contentView addSubview:labelReview];
        
        
        

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
