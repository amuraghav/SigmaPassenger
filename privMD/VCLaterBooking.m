//
//  VCLaterBooking.m
//  CarConnect
//
//  Created by admin on 07/10/16.
//  Copyright © 2016 Rahul Sharma. All rights reserved.
//

#import "VCLaterBooking.h"
#import "XDKAirMenuController.h"
#import "CustomNavigationBar.h"
#import "LaterBookingTableViewCell.h"

@interface VCLaterBooking ()<CustomNavigationBarDelegate>

@end

@implementation VCLaterBooking

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomNavigationBar];
    // Do any additional setup after loading the view.
}





- (void) addCustomNavigationBar{
    
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"LATER BOOKINGS"];
    [self.view addSubview:customNavigationBarView];
    
}


-(void)sendServicegetPatientAppointment
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading.."];
    
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *month ;
//    = [self getMonths];
    
    NSDictionary *params =  @{ @"ent_sess_token":sessionToken,
                               @"ent_dev_id": deviceId,
                               @"ent_date_time":[Helper getCurrentDateTime],
                               @"ent_appnt_dt":month
                               };
    
    NetworkHandler *network = [NetworkHandler sharedInstance];
    [network composeRequestWithMethod:@"getSlaveAppointments" paramas:params
                         onComplition:^(BOOL success , NSDictionary *response){
                             
                             [[ProgressIndicator sharedInstance] hideProgressIndicator];
                             if (success) {
//                                 [self getPatientAppointmentResponse:response];
                             }
                             else{
                                 [[ProgressIndicator sharedInstance] hideProgressIndicator];
                                 
                             }
                         }];
}












-(void)leftBarButtonClicked:(UIButton *)sender{
    [self menuButtonclicked];
}

- (void)menuButtonclicked
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"LaterBookingIdentifier";
    
    LaterBookingTableViewCell *cell =(LaterBookingTableViewCell *) [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LaterBookingTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
//    [cell.imageView setImageWithURL:[NSURL URLWithString:@"http://example.com/image.jpg"]
//                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.NameLabel.text = @"My Text";
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
