//
//  PatientGetLocalCurrency.m
//  UBER
//
//  Created by Rahul Sharma on 14/08/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "PatientGetLocalCurrency.h"

@implementation PatientGetLocalCurrency


+(NSString *)getCurrencyLocal:(float)amount {

    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setLocale:[NSLocale currentLocale]];
    [currencyFormatter setMaximumFractionDigits:2];
    [currencyFormatter setMinimumFractionDigits:2];
    [currencyFormatter setAlwaysShowsDecimalSeparator:YES];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSNumber *someAmount = [NSNumber numberWithFloat:amount];
    NSString *Currencystring = [currencyFormatter stringFromNumber:someAmount];
    return Currencystring;
}



@end
