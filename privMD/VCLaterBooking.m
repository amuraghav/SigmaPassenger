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

@interface VCLaterBooking ()<CustomNavigationBarDelegate>{
    NSMutableArray *laterBookingArr;
}

@end

@implementation VCLaterBooking

- (void)viewDidLoad {
    [super viewDidLoad];
    laterBookingArr = [[NSMutableArray alloc] init];
    [self addCustomNavigationBar];
    [self sendServicegetPatientAppointment];
    // Do any additional setup after loading the view.
}





- (void) addCustomNavigationBar{
    
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"RESERVATIONS"];
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
    
//    = [self getMonths];
    
    NSDictionary *params =  @{ @"ent_sess_token":sessionToken,
                               @"ent_dev_id": deviceId
                               };
    
    NetworkHandler *network = [NetworkHandler sharedInstance];
    [network composeRequestWithMethod:@"getlaterappointmentofcus" paramas:params
                         onComplition:^(BOOL success , NSDictionary *response){
                             
                             [[ProgressIndicator sharedInstance] hideProgressIndicator];
                             if (success) {

                                 if([[response objectForKey:@"errFlag"] isEqualToString :@"0"])
{
                                     
                                     [self showLaterBooking:[response objectForKey:@"later_appointment"]];
                                 
                                 }
                                 else{
                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"errMsg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                     [alertView show];

                                 }
                             }
                             else{
                                 [[ProgressIndicator sharedInstance] hideProgressIndicator];
                                 
                             }
                         }];
}






-(void)showLaterBooking:(NSMutableArray *)arr{
    if([arr count]>0){
        laterBookingArr = arr;
        [_bookingsTableView reloadData];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"YOU DON'T HAVE ANY LATER BOOKING" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

    }
    
    
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
    
    return [laterBookingArr count];    //count number of row from counting array hear cataGorry is An Array
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
    cell.DateAndTimeLabel.text = [[laterBookingArr objectAtIndex:(int)[indexPath row]] objectForKey:@"appointment_dt"];
    cell.DropLocationLabel.text = [[laterBookingArr objectAtIndex:(int)[indexPath row]] objectForKey:@"drop_addr2"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
