//
//  footerCell.h
//  Philemon
//
//  Created by puran on 15/06/15.
//  Copyright (c) 2015 puran. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol buttonindexPressedOnTable <NSObject>
@required
-(void)DoneButtonPressedOnTable:(UIButton*)index;

@end

@interface footerCell : UITableViewCell{
    
    id<buttonindexPressedOnTable>__weak delegate;
    
}
@property (weak, nonatomic) IBOutlet UIButton *_btnDone;

@property(nonatomic, weak)id delegate;

- (IBAction)btnPressed:(id)sender;


@end
