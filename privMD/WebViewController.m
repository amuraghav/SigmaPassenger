//
//  WebViewController.m
//  Loupon
//
//  Created by Rahul Sharma on 08/01/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView,weburl,titleStr;
@synthesize backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void) createNavLeftButton
//{
//    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
//    UIButton *navCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [navCancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [navCancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];
//
//    [Helper setButton:navCancelButton Text:@"Back" WithFont:Trebuchet_MS FSize:11 TitleColor:[UIColor blueColor] ShadowColor:nil];
//    [navCancelButton setTitle:@"Back" forState:UIControlStateNormal];
//    [navCancelButton setTitle:@"Back" forState:UIControlStateSelected];
//    [navCancelButton setShowsTouchWhenHighlighted:YES];
//    [navCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [navCancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    navCancelButton.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:11];
//    //[navCancelButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
//    
//    // Create a container bar button
//    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navCancelButton];
//   // UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:segmentView];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
//    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
//    
//}


//-(void)cancelButtonClicked
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCustomNavigationBar];
    //[self createNavLeftButton];
   // [self.navigationController.navigationItem setHidesBackButton:YES animated:YES];
   // self.navigationController.navigationBarHidden = NO;
    
    
    webView.delegate= self;
    NSURL *url = [NSURL URLWithString:weburl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@""];
    
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
    
    NSLog(@"%@",titleStr);
    
    [Helper setToLabel:labelTitle Text:titleStr WithFont:@"HelveticaNeue" FSize:15 Color:[UIColor whiteColor]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
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
    [leftNavButton addTarget:self action:@selector(gotoRootViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftNavButton setShowsTouchWhenHighlighted:YES];
    [customNavigationBarView addSubview:leftNavButton];
    [self.view addSubview:customNavigationBarView];
    
    self.navigationController.navigationBarHidden=YES;
    
    
    
}


-(void)gotoRootViewController
{
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)viewWillDisappear:(BOOL)animated
{
    [self.webView stopLoading];
    self.webView.delegate = nil;
    self.navigationController.navigationBarHidden = YES;

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Loading.."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
}


@end
