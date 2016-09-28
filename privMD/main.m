//
//  main.m
//  privMD
//
//  Created by Rahul Sharma on 11/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PatientAppDelegate.h"
#import "UIImage+Additions_568.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        
        [UIImage patchImageNamedToSupport568Resources];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([PatientAppDelegate class]));
    }
}
