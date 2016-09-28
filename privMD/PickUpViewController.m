//
//  PickUpViewController.m
//  DoctorMapModule
//
//  Created by Rahul Sharma on 04/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "PickUpViewController.h"
#import "ProgressIndicator.h"
#import "WebServiceHandler.h"
#import "fareCalculatorViewController.h"
#import "Database.h"
#import "SourceAddress.h"
#import "DestinationAddress.h"

//static NSCache *addressCache = nil;


@interface PickUpViewController ()
@property(nonatomic,assign) BOOL isSearchResultCome;

@end

@implementation PickUpViewController
@synthesize onCompletion;
@synthesize latitude;
@synthesize longitude;
@synthesize locationType;
@synthesize isSearchResultCome;
@synthesize carTypesForLiveBookingServer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (void) sendRequestgetAddress{
    
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading.."];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
   NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&sensor=true&key=AIzaSyC8Wp93bbMkFMa4g6_Zy6Rrc9UIHM7zA2M&location=%@,%@&radius=50000",_searchString,latitude,longitude];
        NSURL *url = [NSURL URLWithString:[Helper removeWhiteSpaceFromURL:strUrl]];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(addressResponse:)];
    
}

- (void)addressResponse:(NSDictionary *)response {
    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
    if (!response) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([response objectForKey:@"Error"]){
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
    }
    else
    {
        NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
        if ([[dictResponse objectForKey:@"statusNumber"] intValue] == 0) {
            NSLog(@"%@",dictResponse);
            _mAddress = [dictResponse[@"results"] mutableCopy];
            isSearchResultCome = YES;
            [_tblView reloadData];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
    isSearchResultCome = NO;
    NSLog(@"%ld",(long)self.carTypesForLiveBookingServer);
    /**
	 *  get all the address for current user
	 */
    appDelegate = (PatientAppDelegate*)[UIApplication sharedApplication].delegate;
    context = [appDelegate managedObjectContext];
    [_searchBarController setFrame:CGRectMake(_searchBarController.frame.origin.x, _searchBarController.frame.origin.y+65, _searchBarController.frame.size.width, _searchBarController.frame.size.height)];
    
    self.navigationController.navigationBar.barTintColor= CLEAR_COLOR;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS-Bold" size:17]}];

    if((locationType == 1) || (locationType == 4))
    {        self.navigationItem.title = @"PICKUP LOCATION";
        _searchBarController.placeholder = @"Pickup Location";
        NSLog(@"%f%f%f%f",_searchBarController.frame.origin.x,_searchBarController.frame.origin.y,_searchBarController.frame.size.width,_searchBarController.frame.size.height);
        
        if (context!=nil)
        {
            arrDBResult = [[NSMutableArray alloc] initWithArray:[Database getSourceAddressFromDataBase]];
        }
    }
    else if(locationType == 2)
    {
        self.navigationItem.title = @"DROPOFF LOCATION";
        _searchBarController.placeholder = @"DropOff Location";
        if (context!=nil)
        {
            arrDBResult = [[NSMutableArray alloc] initWithArray:[Database getDestinationAddressFromDataBase]];
        }

    }
    else if(locationType == 3)
    {
        self.navigationItem.title = @"DROPOFF LOCATION";
        _searchBarController.placeholder = @"DropOff Location";
        if (context!=nil)
        {
            arrDBResult = [[NSMutableArray alloc] initWithArray:[Database getDestinationAddressFromDataBase]];
        }
        
    }
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self createNavLeftButton];

    /**
     *  if Address not present fetch all the cards form service
     */
    if (arrDBResult.count != 0) {
        _mAddress = [arrDBResult mutableCopy];
    }

}
- (void)refresh:(UIRefreshControl *)refreshControl
{
     [self sendRequestgetAddress];
    [refreshControl endRefreshing];
}

-(void) createNavLeftButton
{
  // UIView *navView = [[UIView new]initWithFrame:CGRectMake(0, 0,50, 44)];
     UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    UIButton *navCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navCancelButton addTarget:self action:@selector(dismissViewController:) forControlEvents:UIControlEventTouchUpInside];
    [navCancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];
    
    [Helper setButton:navCancelButton Text:@"BACK" WithFont:Trebuchet_MS FSize:11 TitleColor:[UIColor blackColor] ShadowColor:nil];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateNormal];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateSelected];
    [navCancelButton setShowsTouchWhenHighlighted:YES];
    [navCancelButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [navCancelButton setTitleColor:[UIColor blackColor]  forState:UIControlStateHighlighted];
    navCancelButton.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:11];
    //[navCancelButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];

    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navCancelButton];
   // UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:segmentView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [_searchBarController becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
 
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissViewController:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITableView DataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return _mAddress.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.backgroundColor=[UIColor clearColor];
    
    if(cell==nil)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:Trebuchet_MS size:15];
        cell.detailTextLabel.font = [UIFont fontWithName:Trebuchet_MS size:13];
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    id address =  _mAddress[indexPath.row];
    if ([address isKindOfClass:[SourceAddress class]]) {
        SourceAddress *add = (SourceAddress*)address;
        cell.textLabel.text = add.srcAddress;
        cell.detailTextLabel.text = add.srcAddress2;
    }
    else if ([address isKindOfClass:[DestinationAddress class]]) {
        DestinationAddress *add = (DestinationAddress*)address;
        cell.textLabel.text = add.desAddress;
        cell.detailTextLabel.text =add.desAddress2;
    }
    else {
        
        NSDictionary *dict = (NSDictionary*)address;
        cell.textLabel.text = flStrForObj(dict[@"name"]);
        cell.detailTextLabel.text = flStrForStr(dict[@"formatted_address"]);
        
    }
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Database *db = [[Database alloc]init];
    NSDictionary *addDict;
    if(isSearchResultCome == YES && (locationType == 1 || locationType == 4) ){
        [db addSourceAddressInDataBase:_mAddress[indexPath.row]];
        if (onCompletion) {
            
            NSString *add1 = [NSString stringWithFormat:@"%@",flStrForStr(_mAddress[indexPath.row][@"name"])];
            NSString *add2 = [NSString stringWithFormat:@"%@",flStrForStr(_mAddress[indexPath.row][@"formatted_address"])];
            if (add1.length == 0) {
                
                add1 = [add1 stringByAppendingString:flStrForStr(_mAddress[indexPath.row][@"formatted_address"])];
                add2 = @"";
            }
            
            NSDictionary *location = _mAddress[indexPath.row][@"geometry"][@"location"];
            
            addDict = @{@"address1":add1,
                        @"address2":add2,
                        @"lat":[location objectForKey:@"lat"],
                        @"lng":[location objectForKey:@"lng"],
                        };
            
            onCompletion(addDict,locationType);
        }
    }
    else if(isSearchResultCome == YES && (locationType == 2 || locationType == 3) ){
        [db addDestinationAddressInDataBase:_mAddress[indexPath.row]];
        if (onCompletion) {
            
            NSString *add1 = [NSString stringWithFormat:@"%@",flStrForStr(_mAddress[indexPath.row][@"name"])];
            NSString *add2 = [NSString stringWithFormat:@"%@",flStrForStr(_mAddress[indexPath.row][@"formatted_address"])];
            if (add1.length == 0) {
                //add1 = [add1 stringByAppendingString:@","];
                add1 = [add1 stringByAppendingString:flStrForStr(_mAddress[indexPath.row][@"formatted_address"])];
                add2 = @"";
            }
            
            NSDictionary *location = _mAddress[indexPath.row][@"geometry"][@"location"];
            
            addDict = @{@"address1":add1,
                        @"address2":add2,
                        @"lat":[location objectForKey:@"lat"],
                        @"lng":[location objectForKey:@"lng"],
                        };
            
            onCompletion(addDict,locationType);
        }
    }
    else{
        
        if (locationType == 1 || locationType == 4) {
            arrDBResult = [[NSMutableArray alloc] initWithArray:[Database getSourceAddressFromDataBase]];
            SourceAddress *add = (SourceAddress *)arrDBResult[indexPath.row];
            
            addDict = @{@"address1": add.srcAddress,
                        @"address2":add.srcAddress2,
                        @"lat":add.srcLatitude,
                        @"lng":add.srcLongitude,
                        };
            if (onCompletion) {
                onCompletion(addDict,locationType);
            }
        }
        else {
            arrDBResult = [[NSMutableArray alloc] initWithArray:[Database getDestinationAddressFromDataBase]];
            DestinationAddress *add = (DestinationAddress *)arrDBResult[indexPath.row];
            addDict = @{@"address1": add.desAddress,
                        @"address2":add.desAddress2,
                        @"lat":add.desLatitude,
                        @"lng":add.desLongitude,
                        };
            if (onCompletion) {
                onCompletion(addDict,locationType);
            }
        }
    }
    
    if (_isComingFromMapVCFareButton == YES) {
        
        AppointmentLocation *apLocaion = [AppointmentLocation sharedInstance];
        
        NSString *add = [NSString stringWithFormat:@"%@",flStrForStr(addDict[@"address1"])];
        add = [add stringByAppendingString:@","];
        add = [add stringByAppendingString:flStrForStr(addDict[@"address2"])];
        apLocaion.desAddressLine1 = add;
        apLocaion.dropOffLatitude =  addDict[@"lat"];
        apLocaion.dropOffLongitude = addDict[@"lng"];
        
        
        
        NSDictionary *params = @{@"cLoc":[NSString stringWithFormat:@"%@",apLocaion.currentLongitude],
                                 @"cLat":[NSString stringWithFormat:@"%@",apLocaion.currentLatitude],
                                 @"pLoc":[NSString stringWithFormat:@"%@",apLocaion.pickupLongitude],
                                 @"pLat":[NSString stringWithFormat:@"%@",apLocaion.pickupLatitude],
                                 @"pAddr":apLocaion.srcAddressLine1,
                                 @"dLat":[NSString stringWithFormat:@"%@",apLocaion.dropOffLatitude],
                                 @"dLon":[NSString stringWithFormat:@"%@",apLocaion.dropOffLongitude],
                                 @"dAddr":apLocaion.desAddressLine1,
                                 };
        
        fareCalculatorViewController *fareVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fareVC"];
        fareVC.locationDetails = params;
        fareVC.carTypesForLiveBookingServer=self.carTypesForLiveBookingServer;
        [self.navigationController pushViewController:fareVC animated:YES];
        
    }
    else{
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Result";
}

#pragma mark -
#pragma mark Search Bar Delegates
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:YES];

}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	return YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
	[searchBar resignFirstResponder];
    if (_searchString.length > 3) {
         [self sendRequestgetAddress];
    }
   
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
	[searchBar resignFirstResponder];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@""]){
        if ( [_searchString length] > 0){
            _searchString = [_searchString substringToIndex:[_searchString length] - 1];
        }else{
            _searchString=nil;
        }
    }else if ([text isEqualToString:@"\n"]){
        
    }else{
        if(range.location>0){
            _searchString=[_searchString stringByAppendingString:text];
        }else{
            _searchString=text;
        }
    }
//    if (_searchString.length > 3) {
//        [self sendRequestgetAddress];
//    }
    
   
    
    return YES;
}


@end
