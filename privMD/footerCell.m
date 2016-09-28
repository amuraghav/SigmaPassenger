//
//  footerCell.m
//  Philemon
//
//  Created by puran on 15/06/15.
//  Copyright (c) 2015 puran. All rights reserved.
//

#import "footerCell.h"

@implementation footerCell
@synthesize _btnDone;
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)btnPressed:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(DoneButtonPressedOnTable:)])
    {
        [[self delegate] DoneButtonPressedOnTable:sender];
    }
    
}

@end
