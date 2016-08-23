//
//  UIView+ZHCMessages.m
//  ZHChat
//
//  Created by aimoke on 16/8/9.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "UIView+ZHCMessages.h"

@implementation UIView (ZHCMessages)


- (void)zhc_pinSubview:(UIView *)subview toEdge:(NSLayoutAttribute)attribute withConstant:(CGFloat)constant
{
   [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:attribute
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:subview
                                                     attribute:attribute
                                                    multiplier:1.0f
                                                      constant:constant]];
    
    
    
}

- (void)zhc_pinAllEdgesOfSubview:(UIView *)subview
{
    [self zhc_pinSubview:subview toEdge:NSLayoutAttributeBottom withConstant:0.0f];
    [self zhc_pinSubview:subview toEdge:NSLayoutAttributeTop withConstant:0.0f];
    [self zhc_pinSubview:subview toEdge:NSLayoutAttributeLeading withConstant:0.0f];
    [self zhc_pinSubview:subview toEdge:NSLayoutAttributeTrailing withConstant:0.0f];
}

-(void)zhc_pinFrameOfSubView:(UIView *)subView withFrame:(CGRect)frame
{
    [self zhc_pinSubview:subView toEdge:NSLayoutAttributeLeading withConstant:-frame.origin.x];
    [self zhc_pinSubview:subView toEdge:NSLayoutAttributeTop withConstant:-frame.origin.y];
    [subView addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:frame.size.width]];
     [subView addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:frame.size.height]];
    
    
}






@end
