//
//  TermsnConditionViewController.m
//  privMD
//
//  Created by Rahul Sharma on 27/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "TermsnConditionViewController.h"
#import "WebViewController.h"
@interface TermsnConditionViewController ()

@end

@implementation TermsnConditionViewController
@synthesize link1Button;
@synthesize link2Button;

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
   // [self createNavLeftButton];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]];
   // self.view.backgroundColor=BUTTON_VIEW_Color;
  //  self.navigationItem.title = @"Agreement";
    
     [self addCustomNavigationBar];
    
    link1Button.tag = 100;
    link2Button.tag = 200;
    
    link1Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    link1Button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [link1Button setTitle:@"Terms and Conditions" forState:UIControlStateNormal];
    [link1Button setTitle:@"Terms and Conditions" forState:UIControlStateSelected];
    [link1Button setShowsTouchWhenHighlighted:YES];
    [link1Button setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [link1Button setTitleColor:BLACK_COLOR forState:UIControlStateHighlighted];
    link1Button.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:15];
    [link1Button setBackgroundColor:BUTTON_BG_Color];
    
    
    link1Button.layer.borderWidth=1.0f;
    link1Button.layer.borderColor=[UIColor whiteColor].CGColor;

    
    link2Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    link2Button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [link2Button setTitle:@"Privacy Policy" forState:UIControlStateNormal];
    [link2Button setTitle:@"Privacy Policy" forState:UIControlStateSelected];
    [link2Button setShowsTouchWhenHighlighted:YES];
    [link2Button setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [link2Button setTitleColor:BLACK_COLOR forState:UIControlStateHighlighted];
    link2Button.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:15];
    [link2Button setBackgroundColor:BUTTON_BG_Color];
    
    link2Button.layer.borderWidth=1.0f;
    link2Button.layer.borderColor=[UIColor whiteColor].CGColor;

    
    
    [link1Button addTarget:self action:@selector(linkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [link2Button addTarget:self action:@selector(linkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
   
}

-(void)viewWillAppear:(BOOL)animated {
    
   
}
-(void)linkButtonClicked :(id)sender
{
    [self performSegueWithIdentifier:@"gotoWebView" sender:sender];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"gotoWebView"])
    {
        UIButton *mBtn = (UIButton *)sender;
       
        if (mBtn.tag == 100) {
            
            WebViewController *webView = (WebViewController*)[segue destinationViewController];
            webView.titleStr = @"Terms and Conditions";
            webView.weburl = @"http://auscartaxiapp.onsisdev.info/passenger_terms_and_conditions.php";
            
        }
        else if (mBtn.tag == 200) {
            
            WebViewController *webView = (WebViewController*)[segue destinationViewController];
            webView.titleStr = @"Privacy Policy";
            webView.weburl = @"http://auscartaxiapp.onsisdev.info/privacy.php";
        }
    }
}


-(void)cancelButtonClicked
{
     [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"StripeData"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) addCustomNavigationBar
{
    
    UIView *customNavigationBarView = nil;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0"))
    {
        customNavigationBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
        
    }else{
        customNavigationBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    }
    
    // Add navigationbar item
    
    customNavigationBarView.backgroundColor = NavBarTint_Color;
    
    //Add title
    UILabel *labelTitle = nil;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0"))
    {
        labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    }
    else
    {
        labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    }
    
    [Helper setToLabel:labelTitle Text:@"Agreement" WithFont:@"HelveticaNeue" FSize:15 Color:[UIColor whiteColor]];
    
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [customNavigationBarView setBackgroundColor:BUTTON_NG_Color];
    
    [customNavigationBarView addSubview:labelTitle];
    
    //Add right Navigation button
    
    UIButton *leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0"))
    {
        leftNavButton.frame = CGRectMake(10, 20,50, 44);
    }
    else
    {
        leftNavButton.frame = CGRectMake(10, 0, 50, 44);
    }
    
    [Helper setButton:leftNavButton Text:@"BACK" WithFont:@"HelveticaNeue" FSize:11 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [leftNavButton setShowsTouchWhenHighlighted:YES];
    [leftNavButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBarView addSubview:leftNavButton];
    [self.view addSubview:customNavigationBarView];
    self.navigationController.navigationBar.barTintColor= NavBarTint_Color;
    self.navigationController.navigationBarHidden=YES;
    
}



@end
