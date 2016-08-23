//
//  ZHCMessagesToolbarButtonFactory.m
//  ZHChat
//
//  Created by aimoke on 16/8/19.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCMessagesToolbarButtonFactory.h"
#import "UIColor+ZHCMessages.h"
#import "UIImage+ZHCMessages.h"
#import "NSBundle+ZHCMessages.h"

@interface ZHCMessagesToolbarButtonFactory ()

@property (strong, nonatomic, readonly) UIFont *buttonFont;

@end

@implementation ZHCMessagesToolbarButtonFactory


- (instancetype)init
{
    return [self initWithFont:[UIFont boldSystemFontOfSize:17.0]];
}

- (instancetype)initWithFont:(UIFont *)font
{
    NSParameterAssert(font != nil);
    
    self = [super init];
    if (self) {
        _buttonFont = font;
    }
    
    return self;
}


- (UIButton *)defaultAccessoryButtonItem
{
    UIImage *accessoryImage = [UIImage zhc_defaultAccessoryImage];
    UIImage *normalImage = [accessoryImage zhc_imageMaskedWithColor:[UIColor lightGrayColor]];
    UIImage *highlightedImage = [accessoryImage zhc_imageMaskedWithColor:[UIColor darkGrayColor]];
    
    UIButton *accessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, accessoryImage.size.width, 32.0f)];
    [accessoryButton setImage:normalImage forState:UIControlStateNormal];
    [accessoryButton setImage:highlightedImage forState:UIControlStateHighlighted];
    
    accessoryButton.contentMode = UIViewContentModeScaleAspectFit;
    accessoryButton.backgroundColor = [UIColor clearColor];
    accessoryButton.tintColor = [UIColor lightGrayColor];
    accessoryButton.titleLabel.font = self.buttonFont;
    
    accessoryButton.accessibilityLabel = [NSBundle zhc_localizedStringForKey:@"accessory_button_accessibility_label"];
    
    return accessoryButton;
}

- (UIButton *)defaultSendButtonItem
{
    NSString *sendTitle = [NSBundle zhc_localizedStringForKey:@"send"];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [sendButton setTitle:sendTitle forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor zhc_messagesBubbleBlueColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[[UIColor zhc_messagesBubbleBlueColor] zhc_colorByDarkeningColorWithValue:0.1f] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    sendButton.titleLabel.font = self.buttonFont;
    sendButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    sendButton.titleLabel.minimumScaleFactor = 0.85f;
    sendButton.contentMode = UIViewContentModeCenter;
    sendButton.backgroundColor = [UIColor clearColor];
    sendButton.tintColor = [UIColor zhc_messagesBubbleBlueColor];
    
    CGFloat maxHeight = 32.0f;
    
    CGRect sendTitleRect = [sendTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, maxHeight)
                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:@{ NSFontAttributeName : sendButton.titleLabel.font }
                                                   context:nil];
    
    sendButton.frame = CGRectMake(0.0f,
                                  0.0f,
                                  CGRectGetWidth(CGRectIntegral(sendTitleRect)),
                                  maxHeight);
    
    return sendButton;
}


@end
