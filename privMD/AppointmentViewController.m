//
//  AppointmentViewController.m
//  privMD
//
//  Created by Rahul Sharma on 10/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "AppointmentViewController.h"
#import "XDKAirMenuController.h"
#import "CustomNavigationBar.h"
#import "InvoiceViewController.h"
#import "NetworkHandler.h"

@interface AppointmentViewController () <CustomNavigationBarDelegate>
{
    int noOfEvents;
}
@property (nonatomic, strong) NSMutableDictionary *data;

@end

@implementation AppointmentViewController
@synthesize calendar,calScrollView,calView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSString *)getMonths
{
    NSDate *date = [NSDate date];
    NSCalendar *calendarLoc = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendarLoc components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    // NSInteger Day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPaddingCharacter:@"0"];
    [numberFormatter setMinimumIntegerDigits:2];
    NSString * monthString = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:month]];
    
    NSString *retMonth = [NSString stringWithFormat:@"%ld-%@",(long)year,monthString];
    return retMonth;
}
#pragma mark -Web Service

-(void)sendServicegetPatientAppointment
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.calScrollView withMessage:@"Loading.."];
    
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken];
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *month = [self getMonths];
    
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
                                 [self getPatientAppointmentResponse:response];
                             }
                             else{
                                 [[ProgressIndicator sharedInstance] hideProgressIndicator];
                                 
                             }
                         }];
}

-(void)getPatientAppointmentResponse:(NSDictionary *)response
{
    [[ProgressIndicator sharedInstance] hideProgressIndicator];
    if (!response)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([response objectForKey:@"Error"])
    {
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
        
    }
    else
    {
        NSDictionary *dictResponse=[response mutableCopy];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
            [pi hideProgressIndicator];
            
            NSMutableArray *appointmentsArr = [dictResponse objectForKey:@"appointments"];
            //date
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.data = [[NSMutableDictionary alloc]init];
            
            NSMutableDictionary *apArr = nil;
            for (int i = 0;i<appointmentsArr.count;i++)
            {
                apArr = [appointmentsArr objectAtIndex:i];
                
                NSArray *appDetailArr = [apArr objectForKey:@"appt"];
                NSString *appDate = [apArr objectForKey:@"date"];
                NSDate *dateFormated = [dateFormatter dateFromString:appDate];
                [self addEvents:appDetailArr forDate:dateFormated];
                
            }
            [calendar reload];
            if (calendar.table.contentSize.height + 314 > [UIScreen mainScreen].bounds.size.height-64 ) {
                self.calScrollView.contentSize = CGSizeMake(320, calendar.table.contentSize.height + 314);
                
                CGRect rect = self.calScrollView.frame;
                rect.size.height = calendar.table.contentSize.height + 314;
                
                CGRect rect1 = self.calView.frame;
                rect1.size.height = rect.size.height;
                calView.frame = rect1;
                self.calendar.table.frame = rect;
            }
            
            
        }
        else
        {
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
            
        }
    }
}

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    if (IS_IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    [self addCustomNavigationBar];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if (!calendar) {
        
        calView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64)];
        calScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, 320,[UIScreen mainScreen].bounds.size.height-64)];
        calScrollView.backgroundColor = [UIColor clearColor];
        [calScrollView setScrollEnabled:YES];
        [self.view addSubview:calScrollView];
        
        NSDate *currentdate = [NSDate date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *yourDate = [dateFormatter stringFromDate:currentdate];
        NSDate *date = [dateFormatter dateFromString:yourDate];
        
        
        calendar = [CKCalendarView new];
        calendar.isComingFrom = YES;
        [calendar setBackgroundColor:[UIColor blueColor]];
        CGRect calendarFrame = calendar.frame;
        calendarFrame.origin.y = 0;
        calendar.frame =  calendarFrame;
        
        calendar.date = date;
        
        self.view.backgroundColor = [UIColor whiteColor];
        // 2. Optionally, set up the datasource and delegates
        [calendar setDelegate:self];
        [calendar setDataSource:self];
        // 3. Present the calendar
        [calView addSubview:calendar];
        [calScrollView addSubview:calView];
        [self sendServicegetPatientAppointment];
        
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Custom Methods

#pragma mark- Custom Methods

- (void) addCustomNavigationBar{
    
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"BOOKING"];
    [self.view addSubview:customNavigationBarView];
    
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

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    
    return [self data][date];
    
}
// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)CalendarView willSelectDate:(NSDate *)date
{
    
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date
{
    
}
-(void)tableviewIsReloded {
    
    if (calendar.table.contentSize.height + 314 > [UIScreen mainScreen].bounds.size.height-64 ) {
        self.calScrollView.contentSize = CGSizeMake(320, calendar.table.contentSize.height + 314);
        
        CGRect rect = self.calScrollView.frame;
        rect.size.height = calendar.table.contentSize.height + 314;
        
        CGRect rect1 = self.calView.frame;
        rect1.size.height = rect.size.height;
        calView.frame = rect1;
        self.calendar.table.frame = rect;
    } else {
        self.calScrollView.contentSize = CGSizeMake(320, 0);
        
        CGRect rect = self.calScrollView.frame;
        rect.size.height = [UIScreen mainScreen].bounds.size.height-64;
        CGRect rect1 = self.calView.frame;
        rect1.size.height = rect.size.height;
        calView.frame = rect1;
        
        self.calendar.table.frame = rect;
    }
    
}
//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event
{
    
//    NSDictionary *dictionary = event.info;
//     if ([dictionary[@"statCode"] integerValue] == 9)
//    {
////        PatientAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
////        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
////        InvoiceViewController *invoiceVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"invoiceVC"];
////        
////        invoiceVC.doctorEmail = dictionary[@"email"];
////        invoiceVC.appointmentDate = dictionary[@"apntDt"];
////        invoiceVC.isComingFromBooking = YES;
////        UINavigationController *naviVC =(UINavigationController*) appDelegate.window.rootViewController;
////        [naviVC pushViewController:invoiceVC animated:YES];
//    }
//     else
//    {
//      [Helper showAlertWithTitle:@"Message" Message:@"This Booking is not Completed."];
//    }
    
    
}

-(void)addEvents:(NSArray *)eventsArray forDate:(NSDate*)date
{
    NSMutableArray *myeventsArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *eventsDict = nil; //[[NSMutableDictionary alloc] init];
    
    for (int i =0; i< eventsArray.count ;i++)
    {
        // Create events
        eventsDict = eventsArray[i];
        NSLog(@"event%@",eventsDict);
        CKCalendarEvent* aCKCalendarEvent = [[CKCalendarEvent alloc] init];
        aCKCalendarEvent.title = [eventsDict  objectForKey:@"email"];
        aCKCalendarEvent.image = [eventsDict objectForKey:@"pPic"];
        aCKCalendarEvent.name = [eventsDict objectForKey:@"fname"];
        aCKCalendarEvent.pickAdd = [eventsDict  objectForKey:@"addrLine1"];
        aCKCalendarEvent.desAdd = [eventsDict  objectForKey:@"dropLine1"];
        aCKCalendarEvent.time = [eventsDict objectForKey:@"apntTime"];
        aCKCalendarEvent.distance = [eventsDict objectForKey:@"distance"];
        aCKCalendarEvent.amount = ([[eventsDict objectForKey:@"cancel_status"] length]>0)?[eventsDict objectForKey:@"cancellation_charges"]:[eventsDict  objectForKey:@"amount"];
        aCKCalendarEvent.status = [eventsDict objectForKey:@"status"];
        aCKCalendarEvent.apptType = [eventsDict objectForKey:@"apptType"];
        
        
        aCKCalendarEvent.date = date; //[eventsArray  objectForKey:@"phone"];
        aCKCalendarEvent.info = eventsDict;
        [myeventsArray addObject: aCKCalendarEvent];
    }
    
    [_data setObject:myeventsArray forKey:date];
    
}

-(void)forwardTapped {
    
    NSCalendar *calendar12 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *today = [NSDate date];
    NSDateComponents *c = [NSDateComponents new];
    [c setMonth:1];
    today = [calendar12 dateByAddingComponents:c toDate:today options:0];
    [self sendServicegetPatientAppointment];
}
-(void)backwardTapped {
    
    NSCalendar *calendar12 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *today = [NSDate date];
    NSDateComponents *c = [NSDateComponents new];
    [c setMonth:-1];
    today = [calendar12 dateByAddingComponents:c toDate:today options:0];
    [self sendServicegetPatientAppointment];
}

@end
