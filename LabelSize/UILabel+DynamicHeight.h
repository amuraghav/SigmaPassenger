//
//  UILabel+DynamicHeight.h
//  InsightApp
//
//  Created by Surender Rathore on 15/03/14.
//
//

#import <UIKit/UIKit.h>
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define iOS7_0 @"7.0"

@interface UILabel (DynamicHeight)
-(CGSize)sizeOfMultiLineLabel;

@end
