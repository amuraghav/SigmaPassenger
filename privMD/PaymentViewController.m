//
//  PaymentViewController.m
//  privMD
//
//  Created by Rahul Sharma on 02/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "PaymentViewController.h"
#import "CardLoginViewController.h"
#import "XDKAirMenuController.h"
#import "PaymentDetailsViewController.h"
#import "PaymentCell.h"
#import "Entity.h"
#import "Database.h"
#import "CustomNavigationBar.h"

@interface PaymentViewController ()<CustomNavigationBarDelegate>
@property(strong,nonatomic) UIButton *addPaymentbutton;
@end

@implementation PaymentViewController
@synthesize addPaymentbutton;
@synthesize paymentTable;
@synthesize callback;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_Color;
    
    [self addCustomNavigationBar];
    
    //Table VIew
    [self addCoustomTableView];
    
    /**
     *  get all the cards for current user
     */
    appDelegate = (PatientAppDelegate*)[UIApplication sharedApplication].delegate;
    context = [appDelegate managedObjectContext];
    if (context!=nil)
    {
        arrDBResult = [[NSMutableArray alloc] initWithArray:[Database getCardDetails]];
    }
    
    /**
     *  if cards not present fetch all the cards form service
     */
    if (arrDBResult.count == 0) {
        
        //[self sendServicegetCardDetail];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardIsDeleted:) name:kNotificationCardDeletedNameKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardIsAdded:) name:kNotificationNewCardAddedNameKey object:nil];
    
    
    [btnCard setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btnCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCard.titleLabel.font = [UIFont systemFontOfSize:15];
    btnCard.layer.cornerRadius = 2;
    btnCard.layer.borderWidth=1.0f;
    btnCard.layer.borderColor=[UIColor whiteColor].CGColor;

    
    [btnCase setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btnCase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnCase.titleLabel.font = [UIFont systemFontOfSize:15];
    btnCase.layer.cornerRadius = 2;
    btnCase.layer.borderWidth=1.0f;
    btnCase.layer.borderColor=[UIColor whiteColor].CGColor;

    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addCoustomTableView
{
    CGFloat x = 10;
    CGFloat y = 74;
    CGFloat width = self.view.frame.size.width-20;
    CGFloat height = self.view.frame.size.height;
    
    CGRect tableFrame;
    tableFrame = CGRectMake(x, y, width, height - 74);
    paymentTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    paymentTable.sectionFooterHeight = 11;
    paymentTable.sectionHeaderHeight = 2;
    paymentTable.scrollEnabled = YES;
    paymentTable.showsVerticalScrollIndicator = NO;
    paymentTable.userInteractionEnabled = YES;
    paymentTable.backgroundColor = [UIColor clearColor];
    paymentTable.delegate = self;
    paymentTable.dataSource = self;
    paymentTable.tag =1;
    paymentTable.separatorColor = [UIColor blackColor];
    
    
    //TODO :: FOR HIDDEN
  //  paymentTable.hidden=YES;

    
    [self.view addSubview:paymentTable];
    
}

//TODO :: ADD NEW METHOD FOR PAYMENT TYPE
-(IBAction)choose_payment:(id)sender{
    
    paymentShowview.hidden=YES;
    UIButton *mBtn = (UIButton *)sender;
    
    appDelegate = (PatientAppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSInteger btnTag = mBtn.tag;
    
    if (btnTag == 0) {
        
        paymentTable.hidden=NO;
        
        
    }else{
        
        appDelegate.paymentTypevalue=@"cash";
        NSString *cardId = @"CASH";
        NSString *type   = @"";
        // [[NSUserDefaults standardUserDefaults] setObject:itemList[@"cards"][@"id"] forKey:@"CardId"];
        //  [[NSUserDefaults standardUserDefaults] synchronize];
        if (callback) {
            callback(cardId,type);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}



-(void)cardDetailsButtonClicked:(id)sender
{
    UIButton *mBtn = (UIButton *)sender;
    isGoingDelete = YES;
    _dict =   _arrayContainingCardInfo[mBtn.tag];
    // [Helper showAlertWithTitle:@"Message" Message:@"Not done now"];
    [self performSegueWithIdentifier:@"goToPaymentDetail" sender:self];
}

-(void)cardDetailsClicked:(NSDictionary *)getDict
{
    _dict =  [getDict mutableCopy];
    // [Helper showAlertWithTitle:@"Message" Message:@"Not done now"];
    [self performSegueWithIdentifier:@"goToPaymentDetail" sender:self];
}

-(void)addPayment
{
    [self performSegueWithIdentifier:@"goTocardScanController" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goToPaymentDetail"])
    {
        PaymentDetailsViewController *PDVC = [segue destinationViewController];
        PDVC.containingDetailsOfCard = _dict;
        PDVC.callback = ^()
        {
            //isGoingDelete = NO;
            [self sendServicegetdeleteCard];
        };
    }
    else
    {
        CardLoginViewController *CLVC = [segue destinationViewController];
        CLVC.isComingFromPayment = 1;
        TELogInfo(@"addPayment CLVC = %@",CLVC);
    }
    
}

- (void)menuButtonPressedAccount
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

-(void)cancelButtonPressedAccount
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) addCustomNavigationBar
{
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"PAYMENT TYPE"];
    [customNavigationBarView setBackgroundColor:BUTTON_NG_Color];
    if(_isComingFromSummary == YES)
    {
        [customNavigationBarView setLeftBarButtonTitle:@""];
        [customNavigationBarView setleftBarButtonImage:[UIImage imageNamed:@"payment_cancel_btn_off.png"] :[UIImage imageNamed:@"payment_cancel_btn_on.png"]];
    }
    [self.view addSubview:customNavigationBarView];
    
}

-(void)leftBarButtonClicked:(UIButton *)sender
{
    if(_isComingFromSummary == YES)
    {
        [self cancelButtonPressedAccount];
    }
    else{
        [self menuButtonPressedAccount];
    }
}
-(void)rightBarButtonClicked:(UIButton *)sender
{
    
}

#pragma mark - WebService call

-(void)sendServicegetCardDetail
{
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Loading..."];
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *parameters = [NSString stringWithFormat:@"ent_sess_token=%@&ent_dev_id=%@&ent_date_time=%@",[[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken],deviceId,[Helper getCurrentDateTime]];
    
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    TELogInfo(@"request doctor around you :%@",parameters);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@getCards",BASE_URL]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(getCardDetails:)];
    
}

-(void)getCardDetails:(NSDictionary *)response
{
    
    
    TELogInfo(@"response:%@",response);
    if (!response)
    {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([response objectForKey:@"Error"])
    {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
        
    }
    else
    {
        NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
            
            _arrayContainingCardInfo = dictResponse[@"cards"];
            
            [self addInDataBase];
            //  arrDBResult = [_arrayContainingCardInfo mutableCopy];
            NSArray *tempArray;
            tempArray = [Database getCardDetails];
            
            for(int i=0;i<[tempArray count];i++)
            {
                [arrDBResult addObject:[tempArray objectAtIndex:i]];
            }
            
            [paymentTable reloadData];
            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
            [pi hideProgressIndicator];
            
        }
        else
        {
            [_arrayContainingCardInfo removeAllObjects];
            [paymentTable reloadData];
            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
            [pi hideProgressIndicator];
            //  [self createLabel];
            
            // [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
        }
    }
}

-(void)sendServicegetdeleteCard
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [[ProgressIndicator sharedInstance]showPIOnView:window withMessage:@"Loading...."];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *parameters = [NSString stringWithFormat:@"ent_sess_token=%@&ent_dev_id=%@&ent_cc_id=%@&ent_date_time=%@",[[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken],deviceId,_dict[@"id"],[Helper getCurrentDateTime]];
    
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    TELogInfo(@"request doctor around you :%@",parameters);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@removeCard",BASE_URL]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(getdeleteCardResponse:)];
    
}

-(void)getdeleteCardResponse:(NSDictionary *)response
{
    //  ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    //  [pi hideProgressIndicator];
    
    TELogInfo(@"getdeleteCardResponse:%@",response);
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
        
        
        NSDictionary *dictResponse=[response objectForKey:@"ItemsList"];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
            [_arrayContainingCardInfo removeAllObjects];
            [self sendServicegetCardDetail];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
}

-(void)sendServicegetForMakingCArdDefault:(NSString *)cardId
{
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Loading..."];
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *parameters = [NSString stringWithFormat:@"ent_sess_token=%@&ent_dev_id=%@&ent_date_time=%@&ent_cc_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken],deviceId,[Helper getCurrentDateTime],cardId];
    NSLog(@"%@",cardId);
    
    NSString *removeSpaceFromParameter=[Helper removeWhiteSpaceFromURL:parameters];
    TELogInfo(@"request doctor around you :%@",parameters);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@makeCardDefault",BASE_URL]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:[[removeSpaceFromParameter stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                             dataUsingEncoding:NSUTF8StringEncoding
                             allowLossyConversion:YES]];
    
    [handler placeWebserviceRequestWithString:theRequest Target:self Selector:@selector(defaultCardResponse:)];
    
}
-(void)defaultCardResponse:(NSDictionary*)response {
    NSLog(@"dfdsf%@",response);
    //check if response is not null
    if(response == nil) {
        //hide progress indicator
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        return;
    }
    
    //check for network error
    if (response[@"Error"]) {
        //hide progress indicator
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        [Helper showAlertWithTitle:@"Error" Message:response[@"Error"]];
    }
    else {
        //hide progress indicator
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        //handle response here
        NSDictionary *itemList = [[NSDictionary alloc]initWithDictionary:[response objectForKey:@"ItemsList"]];
        
        NSMutableArray *cardArr = [itemList objectForKey:@"cards"];
        
        NSDictionary *cardDetails = [cardArr objectAtIndex:0];
        NSString *cardId = cardDetails[@"last4"];
        NSString *type   = cardDetails[@"type"];
        
        // [[NSUserDefaults standardUserDefaults] setObject:itemList[@"cards"][@"id"] forKey:@"CardId"];
        //  [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (callback) {
            callback(cardId,type);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)setPlaceholderToCardType:(NSString *)mycardType :(NSInteger)mytag :(NSInteger)viewTag
{
    // PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:cardNumberField.text];
    //  PKCardType cardType      = [cardNumber cardType];
    int k = 0;
    UIView *my = [self.view viewWithTag:viewTag];
    UIImageView *image = (UIImageView *) [my viewWithTag:mytag];
    
    NSString* cardTypeName   = @"placeholder";
    if([mycardType isEqualToString:@"amex"])
        k=1;
    else if([mycardType isEqualToString:@"diners"])
        k=2;
    else if([mycardType isEqualToString:@"discover"])
        k=3;
    else if([mycardType isEqualToString:@"jcb"])
        k=4;
    else if([mycardType isEqualToString:@"MasterCard"])
        k=5;
    else if([mycardType isEqualToString:@"Visa"])
        k=6;
    
    switch (k ) {
        case 1:
            cardTypeName = @"amex";
            break;
        case 2:
            cardTypeName = @"diners";
            break;
        case 3:
            cardTypeName = @"discover";
            break;
        case 4:
            cardTypeName = @"jcb";
            break;
        case 5:
            cardTypeName = @"mastercard";
            break;
        case 6:
            cardTypeName = @"visa.png";//PaymentKit/PaymentKit/Resources/Cards/amex.png
            break;
        default:
            break;
    }
    
    
    [image setImage:[UIImage imageNamed:cardTypeName]];
}


#pragma mark -UITABLEVIEW DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrDBResult.count + 1;
    // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
    PaymentCell *cell = nil; //[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell =[[PaymentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellAccessoryNone;
        
        cell.backgroundColor=[BUTTON_BG_Color colorWithAlphaComponent:1];
        tableView.backgroundColor=[UIColor clearColor];
        
        // cell.contentView.layer.borderColor = [UIColor grayColor].CGColor;
        // cell.contentView.layer.borderWidth = 1;
        // cell.contentView.layer.cornerRadius = 2;
        // cell.backgroundColor = [UIColor clearColor];
    }
    
    if(indexPath.row == arrDBResult.count)
    {
        UIImageView *addpaymentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17,17,17)];
        addpaymentIcon.image = [UIImage imageNamed:@"payment_add.png"];
        [cell.contentView addSubview:addpaymentIcon];
        
        UILabel *labelAddpayment = [[UILabel alloc] initWithFrame:CGRectMake(52, 0, 200, 50)];
        [Helper setToLabel:labelAddpayment Text:@"Add Card" WithFont:Trebuchet_MS FSize:15 Color:[UIColor whiteColor]];
        [cell.contentView addSubview:labelAddpayment];
    } 
    else
    {
        
        Entity *fav = arrDBResult[indexPath.row];
        NSString *str = @"****";
        str = [str stringByAppendingString:fav.last4];
        cell.cardLast4Number.text = flStrForObj(str);
        cell.cardLast4Number.textColor=[UIColor whiteColor];
        cell.cardPersonal.text = @"PERSONAL";
        cell.cardPersonal.textColor=[UIColor whiteColor];
        [cell setPlaceholderToCardType:fav.cardtype];
        if(_isComingFromSummary == YES)
        {
            RadioButton *cardRadionButton = [[RadioButton alloc] initWithFrame:CGRectMake(240,13,25,25)];
            [cell.contentView addSubview:cardRadionButton];
            [cardRadionButton setGroupID:100 AndID:indexPath.row AndTitle:@"title"];
            cardRadionButton.delegate =self;
        }
        
    }
    
    if(indexPath.row == arrDBResult.count)
    {
        if (arrDBResult.count == 0) {
            cell.cellBgImage.image = [UIImage imageNamed:@"selectpayment_textlayout_top.png"];
        }
        else
        {
            cell.cellBgImage.image = [UIImage imageNamed:@"selectpayment_textlayout_bottom.png"];
        }
        
    }
    else if(indexPath.row == 0)
    {
        cell.cellBgImage.image = [UIImage imageNamed:@"selectpayment_textlayout_top.png"];
    }
    else
    {
        cell.cellBgImage.image = [UIImage imageNamed:@"selectpayment_textlayout_middle.png"];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    footerView.backgroundColor = [UIColor clearColor];
    
    //    UILabel *poweredByLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 100, 21)];
    //    [Helper setToLabel:poweredByLabel Text:@"Powered by" WithFont:ZURICH_Roman_CONDENSED FSize:12 Color:UIColorFromRGB(0x999999)];
    //    poweredByLabel.textAlignment = NSTextAlignmentLeft;
    //    [footerView addSubview:poweredByLabel];
    //
    //    UIImageView *stripeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(poweredByLabel.frame.size.width+poweredByLabel.frame.origin.x+2, 15, 51, 21)];
    //    stripeImageView.image = [UIImage imageNamed:@"selectpayment_stripe_icn.png"];
    //    [footerView addSubview:stripeImageView];
    
    
    //    UILabel *andLabel = [[UILabel alloc] initWithFrame:CGRectMake(stripeImageView.frame.size.width+stripeImageView.frame.origin.x+2, 14, 30, 21)];
    //    andLabel.textAlignment = NSTextAlignmentCenter;
    //    [Helper setToLabel:andLabel Text:@"and" WithFont:ZURICH_Roman_CONDENSED FSize:15 Color:UIColorFromRGB(0x999999)];
    //    [footerView addSubview:andLabel];
    //
    //    UIImageView *paypalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(andLabel.frame.size.width+andLabel.frame.origin.x+2, 18, 63, 17)];
    //    paypalImageView.image = [UIImage imageNamed:@"selectpayment_paypal_icn.png"];
    //    [footerView addSubview:paypalImageView];
    
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_isComingFromSummary == NO)
    {
        if(arrDBResult.count == indexPath.row)
        {
            [self addPayment];
            
        }
        else
        {
            Entity *fav = arrDBResult[indexPath.row];
            NSMutableDictionary *getDetailsfromDB = [[NSMutableDictionary alloc]init];
            [getDetailsfromDB setObject:fav.expMonth forKey:@"exp_month"];
            [getDetailsfromDB setObject:fav.expYear forKey:@"exp_year"];
            [getDetailsfromDB setObject:fav.cardtype forKey:@"type"];
            [getDetailsfromDB setObject:fav.last4 forKey:@"last4"];
            [getDetailsfromDB setObject:fav.idCard forKey:@"id"];
            
            [self cardDetailsClicked:getDetailsfromDB];
        }
    }
    else
    {
        if(arrDBResult.count == indexPath.row)
        {
            
            CardLoginViewController *vc = (CardLoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"cardLogin"];
            vc.isComingFromPayment = 2;
            UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:vc];
            //[self.navigationController pushViewController:vc animated:YES];
            [self presentViewController:navBar animated:YES completion:nil];
            // [self presentViewController:vc animated:YES completion:nil];
            
            
        }
        else
        {
            Entity *event = [arrDBResult objectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:[event idCard] forKey:@"idOfSelectedCard"];
            [self sendServicegetForMakingCArdDefault:event.idCard];
        }
    }
}

//- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if(section == 2)
//    {
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,20, tableView.bounds.size.width,40)];
//    UIButton *expenseButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    expenseButton.frame = CGRectMake(0,0,tableView.bounds.size.width,40);
//    [Helper setButton:expenseButton Text:@"Expense this trip" WithFont:Comfortaa_Light FSize:15 TitleColor:[UIColor blackColor] ShadowColor:nil];
//    [expenseButton addTarget:self action:@selector(cancelButtonPressedAccount) forControlEvents:UIControlEventTouchUpInside];
//    [expenseButton setBackgroundColor:[UIColor redColor]];
//    [headerView addSubview:expenseButton];
//
//        headerView.backgroundColor = [UIColor greenColor];
//
//    return headerView;
//    }
//    return nil;
//}

#pragma mark - RadioButtonDelegate

-(void)stateChangedForGroupID:(NSUInteger)indexGroup WithSelectedButton:(NSUInteger)indexID
{
    Entity *event = [arrDBResult objectAtIndex:indexID];
    [[NSUserDefaults standardUserDefaults] setObject:[event idCard] forKey:@"idOfSelectedCard"];
    [self sendServicegetForMakingCArdDefault:event.idCard];
    
}

//DAtaBase

-(void)addInDataBase
{
    Database *db = [[Database alloc] init];
    [self checkCampaignIdAddedOrNot];
    if(isPresentInDBalready != 1)
    {
        for (int i =0; i<_arrayContainingCardInfo.count; i++)
        {
            [db makeDataBaseEntry:_arrayContainingCardInfo[i]];
        }
    }
    
}
- (void)checkCampaignIdAddedOrNot
{
    isPresentInDBalready = 0;
    NSArray *array = [Database getCardDetails];
    if ([array count]== 0)
    {
        // if(flag)
        //[self AddToFavButtonClicked:nil];
    }
    else
    {
        for(int i=0 ; i<[array count];i++)
        {
            Entity *fav = [array objectAtIndex:i];
            if ([fav.idCard isEqualToString:_arrayContainingCardInfo[i][@"id"]])
            {
                isPresentInDBalready = 1;
                break;
                
            }
        }
    }
}


-(void)cardIsAdded:(NSNotification *)notification{
    
    if (arrDBResult) {
        [arrDBResult removeAllObjects];
    }
    
    [arrDBResult addObjectsFromArray:[Database getCardDetails]];
    [paymentTable reloadData];
    
}
-(void)cardIsDeleted:(NSNotification *)notification{
    if (arrDBResult) {
        [arrDBResult removeAllObjects];
    }
    
    [arrDBResult addObjectsFromArray:[Database getCardDetails]];
    [paymentTable reloadData];
}


@end
