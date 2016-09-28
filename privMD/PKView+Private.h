//
//  PKView+Private.h
//  privMD
//
//  Created by Surender Rathore on 04/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "PTKView.h"

@interface PTKView (Private)
- (void)setPlaceholderToCardType;
- (void)textFieldIsValid:(UITextField *)textField;
- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors;
- (void)stateMeta;
- (void)stateCardCVC;
@end
