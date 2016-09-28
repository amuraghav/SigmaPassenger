//
//  PaymentCell.h
//  privMD
//
//  Created by Rahul Sharma on 10/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@interface PaymentCell : UITableViewCell


@property(strong,nonatomic) UIImageView *cardImage;
@property(strong,nonatomic) UILabel *cardPersonal;
@property(strong,nonatomic) UILabel *cardLast4Number;
@property(strong,nonatomic) UIButton *addPaymentbutton;
@property(strong,nonatomic) UIImageView *cellBgImage;

-(void)setPlaceholderToCardType:(NSString *)mycardType;

@end
