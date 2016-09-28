//
//  ContactViewController.m
//  CarConnect
//
//  Created by Appypie Inc on 23/10/15.
//  Copyright (c) 2015 Rahul Sharma. All rights reserved.
//

#import "ContactViewController.h"
#import "CustomNavigationBar.h"
#import "XDKAirMenuController.h"

@interface ContactViewController ()<CustomNavigationBarDelegate>

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCustomNavigationBar];
  
}
- (void) addCustomNavigationBar
{
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"CONTACT"];
    [self.view addSubview:customNavigationBarView];
    
    [customNavigationBarView setBackgroundColor:BUTTON_NG_Color];
    
}
-(void)leftBarButtonClicked:(UIButton *)sender{
    
    //    CGRect frame = mainScrollView.frame;
    //    frame.origin.x = 0;
    //    frame.origin.y = 64;
    //    [mainScrollView scrollRectToVisible:frame animated:YES];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
