//
//  PaymentViewController.h
//  privMD
//
//  Created by Rahul Sharma on 02/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKView.h"
#import "RadioButton.h"

typedef void (^ChooseCardCallback)(NSString *cardId , NSString *type);
@interface PaymentViewController : UIViewController <PTKViewDelegate,UITableViewDataSource,UITableViewDelegate,RadioButtonDelegate>
{
    BOOL isGoingDelete;
    int isPresentInDBalready;
    PatientAppDelegate *appDelegate;
    NSMutableArray		*arrDBResult;
	NSManagedObjectContext *context;
    
    IBOutlet UIButton *btnCase;
    IBOutlet UIButton *btnCard;
    
    
    IBOutlet UIView *paymentShowview;
}

@property (nonatomic,copy) ChooseCardCallback callback;
@property (strong,nonatomic) PTKView *paymentView;
@property (assign,nonatomic) BOOL isComingFromSummary;
@property (strong,nonatomic) NSMutableArray *arrayContainingCardInfo;
@property (strong,nonatomic) NSDictionary *dict;
@property (strong,nonatomic) UITableView *paymentTable;

-(IBAction)cancel_Action:(id)sender;
-(IBAction)choose_payment:(id)sender;

@end
