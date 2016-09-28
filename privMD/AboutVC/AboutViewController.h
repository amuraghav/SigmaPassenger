//
//  AboutViewController.h
//  UBER
//
//  Created by Rahul Sharma on 21/05/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *topViewevery1Label;
@property (weak, nonatomic) IBOutlet UILabel *topviewroadyoLabel;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *legalButton;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;

- (IBAction)rateButtonClicked:(id)sender;
- (IBAction)likeonFBButtonClicked:(id)sender;
- (IBAction)legalButtonClicked:(id)sender;
- (IBAction)detailsButtonClicked:(id)sender;
@end
