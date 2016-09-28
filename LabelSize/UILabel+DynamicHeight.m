//
//  UILabel+DynamicHeight.m
//  InsightApp
//
//  Created by Surender Rathore on 15/03/14.
//
//

#import "UILabel+DynamicHeight.h"

@implementation UILabel (DynamicHeight)

-(CGSize)sizeOfMultiLineLabel{
    
    NSAssert(self, @"UILabel was nil");
    
    //Label text
    NSString *aLabelTextString = [self text];
    
    //Label font
    UIFont *aLabelFont = [self font];
    
    //Width of the Label
    CGFloat aLabelSizeWidth = self.frame.size.width;
    
    
    if (SYSTEM_VERSION_LESS_THAN(iOS7_0)) {
        //version < 7.0
        
        return [aLabelTextString sizeWithFont:aLabelFont
                            constrainedToSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                lineBreakMode:NSLineBreakByWordWrapping];
        
      
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(iOS7_0)) {
        //version >= 7.0
        
        //Return the calculated size of the Label
        return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                                        NSFontAttributeName : aLabelFont
                                                        }
                                              context:nil].size;
        
    }
    
    return [self bounds].size;
    
}
@end
