//
//  LocationServicesMessageVC.m
//  privMD
//
//  Created by Surender Rathore on 22/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "LocationServicesMessageVC.h"

@interface LocationServicesMessageVC ()

@end

@implementation LocationServicesMessageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
self.navigationItem.title = @"LOCATION";
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationServicesChanged:) name:kNotificationLocationServicesChangedNameKey object:nil];
    // Do any additional setup after loading the view.
}

/*
-(void)viewWillAppear:(BOOL)animated{
    //check location services is enabled
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus]  == kCLAuthorizationStatusAuthorized) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
}
-(void)locationServicesChanged:(NSNotification*)notification{
    
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus]  == kCLAuthorizationStatusAuthorized) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLocationServicesChangedNameKey object:nil];
}
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
