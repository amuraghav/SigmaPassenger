//
//  HelpViewController.m
//  privMD
//
//  Created by Rahul Sharma on 11/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "HelpViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import <Canvas/CSAnimationView.h>
#import "UILabel+DynamicHeight.h"

@interface HelpViewController ()
{
    NSArray *typeO;
    NSArray *typeoDetails;

}
@end

@implementation HelpViewController
@synthesize topView;
@synthesize signInButton;
@synthesize registerButton;
@synthesize mainScrollView;
@synthesize pageControl;
@synthesize orLabel;

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
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"320X567.png"]];
    
    typeO = [[NSArray alloc]initWithObjects:@"SET PICKUP LOCATION",@"CONFIRM PAYMENT",@"GRACEFUL EXIT",@"TELL US HOW IT WENT!",@"",nil];
    typeoDetails = [[NSArray alloc]initWithObjects:@"Move the pin to request a pickup at specific location,or enter your pickup address directly in the search bar.",@"Estimate a fare before you request so you know how much the ride will cost.",@"No need to carry cash.Your fare covers the entire cost of your ride and is charged right to your payment processor.We will mail you a receipt after your trip.",@"Driver ratings and feedback help us provide a 5-star experience with every ride.",@"",@"",nil];
    [self createScrollingView];
    [self.view bringSubviewToFront:topView];
    [self.view bringSubviewToFront:pageControl];
    
    topView.frame = CGRectMake(0,568, 320,65);
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"roadyo_footer.png"]];
    [self animateIn];
    
    [Helper setButton:signInButton Text:@"SIGN IN" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    
    signInButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signInButton setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
    signInButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [signInButton setBackgroundImage:[UIImage imageNamed:@"roadyo_btn_signin_btn"] forState:UIControlStateHighlighted];
  

    [Helper setButton:registerButton Text:@"SIGN UP" WithFont:Trebuchet_MS FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [registerButton setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    registerButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [registerButton setBackgroundImage:[UIImage imageNamed:@"roadyo_btn_register_btn"] forState:UIControlStateHighlighted];
    
  
    orLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"roadyo_btn_or_on.png"]];
 
    _swpLabel.frame = CGRectMake(230,[UIScreen mainScreen].bounds.size.height-64-50,100,30);

    [self.view bringSubviewToFront:_swpLabel];
    [Helper setToLabel:_swpLabel Text:@"SWIPE UP" WithFont:Trebuchet_MS FSize:14 Color:UIColorFromRGB(0xffffff)];

    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(280,[UIScreen mainScreen].bounds.size.height-64-50,50,20)];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = CLEAR_COLOR;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.972 green:0.814 blue:0.050 alpha:1.000];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.922 alpha:1.000];;
    [pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    pageControl.transform = CGAffineTransformMakeRotation(M_PI / 2);
    [pageControl setHidden:YES];

    [self.view addSubview:pageControl];


}
- (void)animateIn
{
    CGRect frameTopview = topView.frame;
    frameTopview.origin.y = self.view.bounds.size.height - 65;;
  
    [UIView animateWithDuration:0.6f animations:^{
        topView.frame = frameTopview;
    }];
}
-(void)createScrollingView {
    
    NSArray *colors = [[NSArray alloc]initWithObjects:
                       [UIImage imageNamed:@"414X736.png"],
                       [UIImage imageNamed:@"landing_pickuplocation-568h"],
                       [UIImage imageNamed:@"landing_payment-568h"],
                       [UIImage imageNamed:@"landing_recipt-568h"],
                       [UIImage imageNamed:@"landing_rating-568h"],
                       nil];
    
    CGRect screen =  [[UIScreen mainScreen]bounds];
    
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320,screen.size.height)];
    mainScrollView.bounces = NO;
    mainScrollView.clipsToBounds = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:mainScrollView];
    
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height * 5);
    
    
    for (int widOffset = 0; widOffset < 5; widOffset++)
    {
        
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = self.mainScrollView.frame.size.height * widOffset;
        frame.size = self.mainScrollView.frame.size;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        imgView.image = [colors objectAtIndex:widOffset];
        
        if(widOffset != 0)
        {
            UIView *txtContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, imgView.frame.size.height/2+40,320, 130)];
            txtContainerView.backgroundColor = CLEAR_COLOR;
            UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0, 300, 30)];
            txtLabel.backgroundColor = CLEAR_COLOR;
            txtLabel.textAlignment = NSTextAlignmentCenter;
            [Helper setToLabel:txtLabel Text:[typeO objectAtIndex:widOffset-1] WithFont:Trebuchet_MS FSize:15 Color:WHITE_COLOR];
            [txtContainerView addSubview:txtLabel];
            
            UILabel *txtDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,30, 280,100)];
            txtDetailLabel.backgroundColor = CLEAR_COLOR;
            txtDetailLabel.numberOfLines = 0;
                        txtDetailLabel.textAlignment = NSTextAlignmentCenter;
            [Helper setToLabel:txtDetailLabel Text:[typeoDetails objectAtIndex:widOffset-1] WithFont:Trebuchet_MS FSize:15 Color:WHITE_COLOR];
            CGSize size = [txtDetailLabel sizeOfMultiLineLabel];
            CGRect rect = txtDetailLabel.frame;
            rect.size.height = size.height;
            txtDetailLabel.frame = rect;
            [txtContainerView addSubview:txtDetailLabel];

            [imgView addSubview:txtContainerView];
        }
        
        [self.mainScrollView addSubview:imgView];
    }
    
    [mainScrollView setPagingEnabled:YES];
    [self.mainScrollView setScrollEnabled:YES];
    pageControl.transform = CGAffineTransformMakeRotation(M_PI/2.0);

}
#pragma mark-scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageHeight = self.mainScrollView.frame.size.height;
    // you need to have a **iVar** with getter for scrollView
    
    float fractionalPage = self.mainScrollView.contentOffset.y / pageHeight;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
  
    if(page>0){
      [_swpLabel setHidden:YES];
        [pageControl setHidden:NO];
    }
    else{
        [_swpLabel setHidden:NO];
        [pageControl setHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButtonClicked:(id)sender
{
  
    UIButton *mBtn = (UIButton *)sender;
    [mBtn setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];
    [self performSegueWithIdentifier:@"SignIn" sender:self];
    
}

- (IBAction)registerButtonClicked:(id)sender
{
    UIButton *mBtn = (UIButton *)sender;
    
    [mBtn setTitleColor:UIColorFromRGB(0xffcc00) forState:UIControlStateHighlighted];

    [self performSegueWithIdentifier:@"SignUp" sender:self];
}

-(void)callPush
{
   // LoginViewController *LVC=[[LoginViewController alloc] init];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
  //  [self.navigationController pushViewController:LVC animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
//   Call Pop
-(void)callPop
{
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
}
- (IBAction)pageControlClicked:(id)sender
{
    TELogInfo(@"pageControl position %ld", (long)[self.pageControl currentPage]);
    //Call to remove the current view off to the left
    unsigned long int page = self.pageControl.currentPage;
    
    CGRect frame = mainScrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = frame.size.width * page;
    [mainScrollView scrollRectToVisible:frame animated:YES];
    
    
}
@end
