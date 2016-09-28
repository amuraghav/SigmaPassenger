//
//  UpdatePasswordViewController.h
//  CarConnect
//
//  Created by puran on 01/10/15.
//  Copyright (c) 2015 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePasswordViewController : UIViewController<UITextFieldDelegate , UINavigationControllerDelegate>{
    
    
    __weak IBOutlet UIView *_viewPassword;
    __weak IBOutlet UITextField *_txtfOldPassword;
    __weak IBOutlet UITextField *_txtfNewPassword;
    __weak IBOutlet UITextField *_txtfConfirmPassword;
    __weak IBOutlet UITextField *_txtfEmailId;
    __weak IBOutlet UIImageView *_imgViewOldPassword;
    __weak IBOutlet UIImageView *_imgViewNewPassword;
    __weak IBOutlet UIImageView *_imgViewConfirmPassword;
    __weak IBOutlet UIButton *_btnSend;
}
- (IBAction)btnPressed:(id)sender;

@end
