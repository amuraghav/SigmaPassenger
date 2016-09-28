//
//  CustomNavigationBar.m
//  privMD
//
//  Created by Surender Rathore on 15/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "CustomNavigationBar.h"

@interface CustomNavigationBar()
@property(nonatomic,strong)UILabel *labelTitle;
@property(nonatomic,strong)UIButton *rightbarButton;
@property(nonatomic,strong)UIButton *leftbarButton;
@end
@implementation CustomNavigationBar
@synthesize labelTitle;
@synthesize rightbarButton;
@synthesize leftbarButton;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        
//        if(IS_IOS7)
//        {
//            [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_navigationbr-568h.png"]]];
//        }
//        else
//        {
//            [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_navigationbr.png"]]];
//        }
        //[self setBackgroundColor:[UIColor colorWithRed:246/255.0 green:206/255.0 blue:18/255.0 alpha:1]];
        self.backgroundColor=NavBarTint_Color;
       
        //title
        labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 40)];
        labelTitle.textAlignment = NSTextAlignmentCenter;
//        [Helper setToLabel:labelTitle Text:@"" WithFont:Trebuchet_MS FSize:16 Color:[UIColor whiteColor]];
        [Helper setToLabel:labelTitle Text:@"" WithFont:Oswald_Light FSize:17 Color:[UIColor whiteColor]];

        [self addSubview:labelTitle];
        
        leftbarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftbarButton.frame = CGRectMake(0,20,44,40);
        [leftbarButton setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
        [leftbarButton setImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateSelected];
        
        //[leftbarButton setTitle:@"MENU" forState:UIControlStateNormal];
        //[leftbarButton setTitle:@"MENU" forState:UIControlStateSelected];
        
        
        [leftbarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftbarButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        leftbarButton.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:11];
        UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
        [leftbarButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
        [leftbarButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftbarButton];

        
    /*
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 1;
        
        self.layer.shadowOffset = CGSizeMake(0,0);
        CGRect shadowPath = CGRectMake(self.layer.bounds.origin.x - 10, self.layer.bounds.size.height+1, self.layer.bounds.size.width + 20, 1.3);
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
        self.layer.shouldRasterize = YES;
     */   
    }
    return self;
}

-(void)createRightBarButton
{
    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
    //rightbutton
    rightbarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbarButton.frame = CGRectMake(276, 20,buttonImage.size.width, buttonImage.size.height);
    rightbarButton.titleLabel.font = [UIFont fontWithName:Trebuchet_MS size:11];
    
    [rightbarButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    [rightbarButton setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateSelected];
    
    //[rightbarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[rightbarButton setTitleColor:[UIColor colorWithWhite:0.384 alpha:1.000] forState:UIControlStateHighlighted];
    
    [rightbarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [rightbarButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [rightbarButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightbarButton];

}

-(void)setTitle:(NSString*)title{
    labelTitle.text = title;
    //[self setNeedsDisplay];
}
-(void)setRightBarButtonTitle:(NSString*)title{
    [rightbarButton setTitle:title forState:UIControlStateNormal];
    //[self setNeedsDisplay];
}
-(void)setLeftBarButtonTitle:(NSString*)title{
    [leftbarButton setTitle:title forState:UIControlStateNormal];
}
-(void)setleftBarButtonImage:(UIImage*)imageOn :(UIImage *)imageOff{
    [leftbarButton setImage:imageOn forState:UIControlStateNormal];
    [leftbarButton setImage:imageOff forState:UIControlStateNormal];
}

-(void)rightBarButtonClicked:(UIButton*)sender{
    if (delegate && [delegate respondsToSelector:@selector(rightBarButtonClicked:)]) {
        [delegate rightBarButtonClicked:sender];
    }
}
-(void)leftBarButtonClicked:(UIButton*)sender {
    if (delegate && [delegate respondsToSelector:@selector(leftBarButtonClicked:)]) {
        [delegate leftBarButtonClicked:sender];
    }
}
@end
