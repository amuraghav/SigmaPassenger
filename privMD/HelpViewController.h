//
//  HelpViewController.h
//  privMD
//
//  Created by Rahul Sharma on 11/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSAnimationView;
@interface HelpViewController : UIViewController<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIView *swipeLabel;
@property (strong, nonatomic) IBOutlet UILabel *physicianLabel;
@property (strong, nonatomic) IBOutlet UILabel *privateLabel;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (strong , nonatomic) UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *swpLabel;

- (IBAction)signInButtonClicked:(id)sender;
- (IBAction)registerButtonClicked:(id)sender;
- (IBAction)pageControlClicked:(id)sender;


@end
