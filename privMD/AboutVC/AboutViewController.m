//
//  AboutViewController.m
//  UBER
//
//  Created by Rahul Sharma on 21/05/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "AboutViewController.h"
#import "XDKAirMenuController.h"
#import "CustomNavigationBar.h"
#import "WebViewController.h"
#import "TermsnConditionViewController.h"

@interface AboutViewController ()<CustomNavigationBarDelegate>

@end

@implementation AboutViewController
@synthesize topView;
@synthesize topViewevery1Label;
@synthesize topviewroadyoLabel;
@synthesize likeButton;
@synthesize legalButton;
@synthesize rateButton;
@synthesize detailButton;

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
    [self addCustomNavigationBar];
   // self.view.backgroundColor = BG_Color;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [Helper setToLabel:topViewevery1Label Text:@"Sigma" WithFont:Trebuchet_MS FSize:13 Color:[UIColor blackColor]];
    [Helper setToLabel:topviewroadyoLabel Text:@"www.ridesigma.com" WithFont:Trebuchet_MS FSize:11 Color:[UIColor blueColor]];

    [Helper setButton:rateButton Text:@"Rate us on the App Store" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor blackColor] ShadowColor:nil];
    rateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    rateButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rateButton setShowsTouchWhenHighlighted:YES];
    [rateButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rateButton setBackgroundImage:[UIImage imageNamed:@"signup_bg_namedetails_line"] forState:UIControlStateHighlighted];
    
    [Helper setButton:likeButton Text:@"Like us on Facebook" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor blackColor] ShadowColor:nil];
    likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    likeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [likeButton setShowsTouchWhenHighlighted:YES];
    [likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"signup_bg_namedetails_line"] forState:UIControlStateHighlighted];
    
    [Helper setButton:legalButton Text:@"Legal" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor blackColor] ShadowColor:nil];
    legalButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    legalButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [legalButton setShowsTouchWhenHighlighted:YES];
    [legalButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    
    // [legalButton setBackgroundImage:[UIImage imageNamed:@"about_cell_selector"] forState:UIControlStateHighlighted];
    // [Helper setButton:detailButton Text:@"Company details" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    // detailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // detailButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    // [detailButton setShowsTouchWhenHighlighted:YES];
    // [detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom Methods -

- (void) addCustomNavigationBar{
  CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"ABOUT"];
    [customNavigationBarView setBackgroundColor:BUTTON_NG_Color];
    [self.view addSubview:customNavigationBarView];
    
}
-(void)leftBarButtonClicked:(UIButton *)sender{
    [self menuButtonPressedAccount];
}

- (void)menuButtonPressedAccount
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

- (IBAction)rateButtonClicked:(id)sender {
    
    WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    webView.titleStr = @"RATE US ON APP STORE";
    webView.weburl = @"https://www.google.com";
    [self.navigationController pushViewController:webView animated:YES];
    

}
- (IBAction)likeonFBButtonClicked:(id)sender {
    
    WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    webView.titleStr = @"LIKE US ON FACEBOOK";
    webView.weburl = @"https://www.facebook.com/Sigma";
    [self.navigationController pushViewController:webView animated:YES];
    
}

- (IBAction)detailsButtonClicked:(id)sender{
    
    WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    webView.titleStr = @"COMPANY DETAILS";
    webView.weburl = @"http://twynsllcapp.onsisdev.info/company.php";
    [self.navigationController pushViewController:webView animated:YES];
    
}

- (IBAction)legalButtonClicked:(id)sender {

    TermsnConditionViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"termsVC"];
    [self.navigationController pushViewController:webView animated:YES];
}

@end
