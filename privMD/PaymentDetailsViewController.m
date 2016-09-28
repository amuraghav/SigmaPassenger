//
//  PaymentDetailsViewController.m
//  privMD
//
//  Created by Rahul Sharma on 05/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "PaymentDetailsViewController.h"
#import "Database.h"
#import "Entity.h"
@interface PaymentDetailsViewController ()
@property(nonatomic,strong)UIButton *rightBarButton;
@end

@implementation PaymentDetailsViewController

@synthesize cardNoLabel,expLabel,expTextField,cvvTextField,personalButton,cardImage,mainView,deleteButton;

@synthesize containingDetailsOfCard;

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor =BUTTON_VIEW_Color;
    
    self.mainView.frame = CGRectMake(10, 70 , 595/2, 220);
    mainView.backgroundColor = NavBarTint_Color;
    
    [Helper setButton:deleteButton Text:@"Delete Card" WithFont:Trebuchet_MS FSize:15 TitleColor:UIColorFromRGB(0x333333) ShadowColor:nil];
    [deleteButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
    [deleteButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    deleteButton.backgroundColor = BUTTON_BG_Color;
    
    deleteButton.layer.borderWidth=1.0f;
    deleteButton.layer.borderColor=[UIColor whiteColor].CGColor;

    [deleteButton setShowsTouchWhenHighlighted:YES];
    self.navigationItem.title = @"CARD DETAILS";
    
    self.navigationController.navigationBar.barTintColor= NavBarTint_Color;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName: [UIFont fontWithName:@"Oswald-light" size:17]}];
    self.navigationController.navigationBar.translucent = NO;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    [self createNavLeftButton];
    [self createNavRightButton];

    NSString *str;
   // [containingDetailsOfCard setValue:str forKey:@"type"];
    
    str = [containingDetailsOfCard objectForKey:@"type"];
    [self setPlaceholderToCardType:str];
    
    NSString *str1 = @"**** **** **** ";
    cardNoLabel.text =  [containingDetailsOfCard objectForKey:@"last4"];
    str1 = [str1 stringByAppendingString:cardNoLabel.text];
    cardNoLabel.text = str1;
    cardNoLabel.font = [UIFont fontWithName:Trebuchet_MS size:15];
  //  cardNoLabel.textColor = UIColorFromRGB(0xffffff);
    cardNoLabel.textColor = [UIColor whiteColor];

    [Helper setToLabel:expLabel Text:@"EXP" WithFont:Trebuchet_MS FSize:15 Color:[UIColor whiteColor]];
    
   // NSString *month = [NSString stringWithFormat:@"%@",[containingDetailsOfCard objectForKey:@"exp_month"]];
    NSString *month = [containingDetailsOfCard objectForKey:@"exp_month"];

    month = [month stringByAppendingString:@"/"];
  //  month = [NSString stringWithFormat:@"%@",[month stringByAppendingString:[containingDetailsOfCard objectForKey:@"exp_year"]]];
    month = [month stringByAppendingString:[containingDetailsOfCard objectForKey:@"exp_year"]];

    //  NSString *year = [containingDetailsOfCard objectForKey:@"exp_year"];

    expTextField.text = month;
    expTextField.font = [UIFont fontWithName:Trebuchet_MS size:15];
//    expTextField.textColor = UIColorFromRGB(0xaeb2b6);
    expTextField.textColor = [UIColor blackColor];
    cvvTextField.hidden = YES;
    cvvTextField.font = [UIFont fontWithName:Trebuchet_MS size:15];
    //cvvTextField.textColor = UIColorFromRGB(0xaeb2b6);
    cvvTextField.textColor = [UIColor blackColor];
    
    [Helper setButton:personalButton Text:@"PERSONAL" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    personalButton.userInteractionEnabled = YES;
    

}


-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0")){
        //deleteButton.frame = CGRectMake(74, 280 , 172, 36);
        deleteButton.frame = CGRectMake(31, 385 ,257, 42);
    }
    else{
         deleteButton.frame = CGRectMake(31, 385 ,257, 42);
    }
}
#pragma mark Custom Methods -
-(void) createNavLeftButton
{

    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    UIButton *navCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navCancelButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [navCancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];

    [Helper setButton:navCancelButton Text:@"BACK" WithFont:Oswald_Light FSize:11 TitleColor:[UIColor blackColor] ShadowColor:nil];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateNormal];
    [navCancelButton setTitle:@"BACK" forState:UIControlStateSelected];
    [navCancelButton setShowsTouchWhenHighlighted:YES];
    [navCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navCancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    navCancelButton.titleLabel.font = [UIFont fontWithName:Oswald_Light size:11];
    //[navCancelButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
   
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navCancelButton];
   // UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:segmentView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
    
  //  self.navigationItem.leftBarButtonItem = containingcancelButton;
}


-(void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createNavRightButton
{
    UIButton *navNextButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    [navNextButton setFrame:CGRectMake(0,0,buttonImage.size.width,buttonImage.size.height)];

    [navNextButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if(IS_IOS7)
    {
        //[navNextButton setFrame:CGRectMake(0,0,44,44)];
    }
    else
    {
        //[navNextButton setFrame:CGRectMake(0,0.0f,44,44)];
    }
    
    [Helper setButton:navNextButton Text:@"EDIT" WithFont:Oswald_Light FSize:11 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    
    [navNextButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
    [navNextButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
    // Create a container bar button
    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navNextButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];

}

- (void)editButtonClicked:(id)sender
{
    UIButton *mBut = (UIButton *)sender;
    // [self setSelectedButtonByIndex:((UIButton *)sender).tag] ;
    
    mBut.userInteractionEnabled = YES;
    
    if(mBut.isSelected)
    {
        mBut.selected =NO;
        cvvTextField.hidden = YES;
        expTextField.userInteractionEnabled = NO;
        [mBut setTitle:@"EDIT" forState:UIControlStateNormal];
        
        
    }
    else
    {
        
        mBut.selected = YES;
        expTextField.userInteractionEnabled = YES;
        cvvTextField.hidden = NO;
        [mBut setTitle:@"SAVE" forState:UIControlStateSelected];

    }
}

-(void)gotoLastController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)personalButtonClicked:(id)sender
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Personal",
                            @"Bussiness",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)deleteButtonClicked:(id)sender {
    
    [self sendServicegetdeleteCard];
//    if(self.callback)
//   {
//        self.callback();
//        //[self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [Helper setButton:personalButton Text:@"PERSONAL" WithFont:@"Helvetica" FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];                    break;
                case 1:
                    [Helper setButton:personalButton Text:@"BUSSINESS" WithFont:@"Helvetica" FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)setPlaceholderToCardType:(NSString *)mycardType
{
    NSString* cardTypeName   = @"placeholder";
    if([mycardType isEqualToString:@"amex"])
        cardTypeName = @"amex";
    else if([mycardType isEqualToString:@"diners"])
        cardTypeName = @"diners";
    else if([mycardType isEqualToString:@"discover"])
        cardTypeName = @"discover";
    else if([mycardType isEqualToString:@"jcb"])
        cardTypeName = @"jcb";
    else if([mycardType isEqualToString:@"MasterCard"])
        cardTypeName = @"mastercard";
    else if([mycardType isEqualToString:@"Visa"])
        cardTypeName = @"visa.png";
    
    [cardImage setImage:[UIImage imageNamed:cardTypeName]];
}


#pragma mark - WebService call

-(void)sendServicegetdeleteCard
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [[ProgressIndicator sharedInstance]showPIOnView:window withMessage:@"Deleting Card...."];
    
    WebServiceHandler *handler = [[WebServiceHandler alloc] init];
    NSString *deviceId;
    if (IS_SIMULATOR) {
        deviceId = kPMDTestDeviceidKey;
    }
    else {
        deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey];
    }
    
    NSString *parameters = [NSString stringWithFormat:@"ent_sess_token=%@&ent_dev_id=%@&ent_cc_id=%@&ent_date_time=%@",[[NSUserDefaults standardUserDefaults]objectForKey:KDAcheckUserSessionToken],deviceId,containingDetailsOfCard[@"id"],[Helper getCurrentDateTime]];
    
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
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
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
            
            BOOL status = [Database DeleteCard:containingDetailsOfCard[@"id"]];
            if (status) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCardDeletedNameKey object:nil userInfo:nil];
                [self gotoLastController];
            }
            [self gotoLastController];
        }
    }
}


#pragma mark
#pragma UITextfieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end
