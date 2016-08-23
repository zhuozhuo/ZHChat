//
//  ZHCMessagesToolbarContentView.m
//  ZHChat
//
//  Created by aimoke on 16/8/19.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCMessagesToolbarContentView.h"
#import "UIView+ZHCMessages.h"

const CGFloat kZHCMessagesToolbarContentViewHorizontalSpacingDefault = 8.0f;


@interface ZHCMessagesToolbarContentView ()

@property (weak, nonatomic) IBOutlet ZHCMessagesComposerTextView *textView;

@property (weak, nonatomic) IBOutlet UIView *leftBarButtonContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBarButtonContainerViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *middleBarButtonContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleBarButtonContainerViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *rightBarButtonContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBarButtonContainerViewWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftHorizontalSpacingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightHorizontalSpacingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleHorizontalSpacingConstraint;
@end

@implementation ZHCMessagesToolbarContentView

#pragma mark - Class methods

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([ZHCMessagesToolbarContentView class])
                          bundle:[NSBundle bundleForClass:[ZHCMessagesToolbarContentView class]]];
}



#pragma mark - Initialization
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.leftHorizontalSpacingConstraint.constant = kZHCMessagesToolbarContentViewHorizontalSpacingDefault;
    self.rightHorizontalSpacingConstraint.constant = kZHCMessagesToolbarContentViewHorizontalSpacingDefault;
    self.middleHorizontalSpacingConstraint.constant = kZHCMessagesToolbarContentViewHorizontalSpacingDefault;
    self.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.leftBarButtonContainerView.backgroundColor = backgroundColor;
    self.middleBarButtonContainerView.backgroundColor = backgroundColor;
    self.rightBarButtonContainerView.backgroundColor = backgroundColor;
}

- (void)setLeftBarButtonItem:(UIButton *)leftBarButtonItem
{
    if (_leftBarButtonItem) {
        [_leftBarButtonItem removeFromSuperview];
    }
    
    if (!leftBarButtonItem) {
        _leftBarButtonItem = nil;
        self.leftHorizontalSpacingConstraint.constant = 0.0f;
        self.leftBarButtonItemWidth = 0.0f;
        self.leftBarButtonContainerView.hidden = YES;
        return;
    }
    
    if (CGRectEqualToRect(leftBarButtonItem.frame, CGRectZero)) {
        leftBarButtonItem.frame = self.leftBarButtonContainerView.bounds;
    }
    
    self.leftBarButtonContainerView.hidden = NO;
    self.leftHorizontalSpacingConstraint.constant = kZHCMessagesToolbarContentViewHorizontalSpacingDefault;
    self.leftBarButtonItemWidth = CGRectGetWidth(leftBarButtonItem.frame);
    
    [leftBarButtonItem setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.leftBarButtonContainerView addSubview:leftBarButtonItem];
    [self.leftBarButtonContainerView zhc_pinAllEdgesOfSubview:leftBarButtonItem];
    [self setNeedsUpdateConstraints];
    
    _leftBarButtonItem = leftBarButtonItem;
}

- (void)setLeftBarButtonItemWidth:(CGFloat)leftBarButtonItemWidth
{
    self.leftBarButtonContainerViewWidthConstraint.constant = leftBarButtonItemWidth;
    [self setNeedsUpdateConstraints];
}

- (void)setMiddleBarButtonItem:(UIButton *)middleBarButtonItem
{
    if (_middleBarButtonItem) {
        [_middleBarButtonItem removeFromSuperview];
    }
    
    if (!middleBarButtonItem) {
        _middleBarButtonItem = nil;
        self.middleHorizontalSpacingConstraint.constant = 0.0f;
        self.middleBarButtonItemWidth = 0.0f;
        self.middleBarButtonContainerView.hidden = YES;
        return;
    }
    
    if (CGRectEqualToRect(middleBarButtonItem.frame, CGRectZero)) {
        middleBarButtonItem.frame = self.middleBarButtonContainerView.bounds;
    }
    
    self.middleBarButtonContainerView.hidden = NO;
    self.middleHorizontalSpacingConstraint.constant = kZHCMessagesToolbarContentViewHorizontalSpacingDefault;
    self.middleBarButtonItemWidth = CGRectGetWidth(middleBarButtonItem.frame);
    
    [middleBarButtonItem setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.middleBarButtonContainerView addSubview:middleBarButtonItem];
    [self.middleBarButtonContainerView zhc_pinAllEdgesOfSubview:middleBarButtonItem];
    [self setNeedsUpdateConstraints];
    
    _middleBarButtonItem = middleBarButtonItem;
}

- (void)setMiddleBarButtonItemWidth:(CGFloat)middleBarButtonItemWidth
{
    self.middleBarButtonContainerViewWidthConstraint.constant = middleBarButtonItemWidth;
    [self setNeedsUpdateConstraints];
}




- (void)setRightBarButtonItem:(UIButton *)rightBarButtonItem
{
    if (_rightBarButtonItem) {
        [_rightBarButtonItem removeFromSuperview];
    }
    
    if (!rightBarButtonItem) {
        _rightBarButtonItem = nil;
        self.rightHorizontalSpacingConstraint.constant = 0.0f;
        self.rightBarButtonItemWidth = 0.0f;
        self.rightBarButtonContainerView.hidden = YES;
        return;
    }
    
    if (CGRectEqualToRect(rightBarButtonItem.frame, CGRectZero)) {
        rightBarButtonItem.frame = self.rightBarButtonContainerView.bounds;
    }
    
    self.rightBarButtonContainerView.hidden = NO;
    self.rightHorizontalSpacingConstraint.constant = kZHCMessagesToolbarContentViewHorizontalSpacingDefault;
    self.rightBarButtonItemWidth = CGRectGetWidth(rightBarButtonItem.frame);
    
    [rightBarButtonItem setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.rightBarButtonContainerView addSubview:rightBarButtonItem];
    [self.rightBarButtonContainerView zhc_pinAllEdgesOfSubview:rightBarButtonItem];
    [self setNeedsUpdateConstraints];
    
    _rightBarButtonItem = rightBarButtonItem;
}

- (void)setRightBarButtonItemWidth:(CGFloat)rightBarButtonItemWidth
{
    self.rightBarButtonContainerViewWidthConstraint.constant = rightBarButtonItemWidth;
    [self setNeedsUpdateConstraints];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
