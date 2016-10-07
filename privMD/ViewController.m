//
//  ViewController.m
//  DoctorMapModule
//
//  Created by Rahul Sharma on 03/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "ViewController.h"
#import "PickUpViewController.h"
#import "PaymentViewController.h"
#import "PatientAppDelegate.h"

@interface ViewController ()<XDKAirMenuDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:NavBarTint_Color];
    [_tableView setBackgroundColor:NavBarTint_Color];
    
    if (IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.airMenuController = [XDKAirMenuController sharedMenu];
    self.airMenuController.airDelegate = self;
    [self.view addSubview:self.airMenuController.view];
    [self addChildViewController:self.airMenuController];
    
    //[self createNavLeftButton];
    
}

-(void) createNavLeftButton
{
    titleview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleview.backgroundColor=[UIColor blackColor];
    UILabel *titlelbl =[[UILabel alloc]initWithFrame:CGRectMake(30, 40, 50, 20)];
    titlelbl.text =@"Sigma";
    titlelbl.textColor=[UIColor whiteColor];
    [titleview addSubview:titlelbl];
    [self.view addSubview:titleview];
    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"123");
}
-(void)viewWillAppear:(BOOL)animated{
    
    //titleview.hidden=NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TableViewSegue"])
    {
        self.tableView = ((UITableViewController*)segue.destinationViewController).tableView;
    }
}


#pragma mark - XDKAirMenuDelegate

- (UIViewController*)airMenu:(XDKAirMenuController*)airMenu viewControllerAtIndexPath:(NSIndexPath*)indexPath
{

    NSLog(@"%ld",(long)indexPath.row);
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *vc = nil;
    
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
     titleview.hidden=YES;
    
    if (indexPath.row == 0)
    {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
        return vc;
    }
    else if (indexPath.row == 1)
    {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"appointmentViewController"];
        return vc;
    }
    if(indexPath.row == 2){
        vc = [storyboard instantiateViewControllerWithIdentifier:@"LaterBooking"];
        return vc;
    }
    if (indexPath.row == 3)
    {
        PatientAppDelegate *appDelegate = (PatientAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate._IsShowPaymentMODE=YES;
        vc = [storyboard instantiateViewControllerWithIdentifier:@"paymentVC"];
        return vc;
    }
    
    if (indexPath.row == 4)
    {
      
      
        
        vc = [storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
        return vc;
    }
//    else if (indexPath.row == 4)
//    {
//        vc = [storyboard instantiateViewControllerWithIdentifier:@"contactViewController"];
//        return vc;
//    }
//    else if(indexPath.row == 5)
//    {
//        vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
//        //vc = [storyboard instantiateViewControllerWithIdentifier:@"rateViewController"];
//        return vc;
//    }

    
    else if(indexPath.row == 5)
    {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"resetPwdViewController"];
        return vc;
    }
    else if(indexPath.row == 6)
    {
         vc = [storyboard instantiateViewControllerWithIdentifier:@"aboutVC"];
         return vc;
    }
    
    
    else
    {
        vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
        return vc;
    }
    
    
}


#pragma mark Webservice Handler(Request) -

- (UITableView*)tableViewForAirMenu:(XDKAirMenuController*)airMenu
{
    return self.tableView;
}

@end
