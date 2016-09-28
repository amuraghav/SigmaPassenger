//
//  PaymentCell.m
//  privMD
//
//  Created by Rahul Sharma on 10/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "PaymentCell.h"

@implementation PaymentCell
@synthesize cardImage,cardPersonal,cardLast4Number;
@synthesize addPaymentbutton,cellBgImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //Section 1
        if (!cellBgImage) {
            cellBgImage =  [[UIImageView alloc] initWithFrame: CGRectMake(0,0,300,50)];
            [self.contentView addSubview:cellBgImage];
            
        }
        
        if (!cardImage)
        {
            cardImage =  [[UIImageView alloc] initWithFrame: CGRectMake(5,15,32,20)];
            [self.contentView addSubview:cardImage];
        }
        if(!cardPersonal)
        {
          cardPersonal =  [[UILabel alloc] initWithFrame: CGRectMake(cardImage.frame.origin.x+cardImage.frame.size.width+15,2,100,50)];
          [Helper setToLabel:cardPersonal Text:@"" WithFont:Trebuchet_MS FSize:15 Color:[UIColor blackColor]];
          [self.contentView addSubview:cardPersonal];
        }
        if(!cardLast4Number)
        {
            cardLast4Number =  [[UILabel alloc] initWithFrame: CGRectMake(cardPersonal.frame.origin.x+cardPersonal.frame.size.width,2,130,50)];
            [Helper setToLabel:cardLast4Number Text:@"" WithFont:Trebuchet_MS FSize:15 Color:[UIColor blackColor]];
            [self.contentView addSubview:cardLast4Number];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPlaceholderToCardType:(NSString *)mycardType
{
    // PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:cardNumberField.text];
    //  PKCardType cardType      = [cardNumber cardType];
    int k = 0;
    
    NSString* cardTypeName   = @"placeholder";
    if([mycardType isEqualToString:@"amex"])
        k=1;
    else if([mycardType isEqualToString:@"diners"])
        k=2;
    else if([mycardType isEqualToString:@"discover"])
        k=3;
    else if([mycardType isEqualToString:@"jcb"])
        k=4;
    else if([mycardType isEqualToString:@"MasterCard"])
        k=5;
    else if([mycardType isEqualToString:@"Visa"])
        k=6;
    
    switch (k ) {
        case 1:
            cardTypeName = @"amex";
            break;
        case 2:
            cardTypeName = @"diners";
            break;
        case 3:
            cardTypeName = @"discover";
            break;
        case 4:
            cardTypeName = @"jcb";
            break;
        case 5:
            cardTypeName = @"mastercard";
            break;
        case 6:
            cardTypeName = @"visa.png";//PaymentKit/PaymentKit/Resources/Cards/amex.png
            break;
        default:
            break;
    }
    
    
    [cardImage setImage:[UIImage imageNamed:cardTypeName]];
}


@end
