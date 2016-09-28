//
//  CustomNavigationBar.h
//  privMD
//
//  Created by Surender Rathore on 15/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomNavigationBarDelegate;
@interface CustomNavigationBar : UIView
@property(nonatomic,weak)id <CustomNavigationBarDelegate> delegate;
-(void)setTitle:(NSString*)title;
-(void)setRightBarButtonTitle:(NSString*)title;
-(void)setLeftBarButtonTitle:(NSString*)title;
-(void)setleftBarButtonImage:(UIImage*)imageOn :(UIImage *)imageOff;
-(void)createRightBarButton;

@end
@protocol CustomNavigationBarDelegate <NSObject>
@optional
-(void)rightBarButtonClicked:(UIButton*)sender;
-(void)leftBarButtonClicked:(UIButton*)sender;
@end
