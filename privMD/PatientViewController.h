//
//  PatientViewController.h
//  privMD
//
//  Created by Rahul Sharma on 11/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PatientViewController : UIViewController<CLLocationManagerDelegate>
{
    CLLocationManager *clmanager;
    
    NSString *strcurrentAddress;
    
}
@end
