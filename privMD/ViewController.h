//
//  ViewController.h
//  DoctorMapModule
//
//  Created by Rahul Sharma on 03/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDKAirMenuController.h"

@interface ViewController : UIViewController
{
    UIView *titleview;
}

@property (nonatomic, strong) XDKAirMenuController *airMenuController;

@end
