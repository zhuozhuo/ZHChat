//
//  UIImage+ZHCMessages.h
//  ZHChat
//
//  Created by aimoke on 16/8/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZHCMessages)

/**
 *  Creates and returns a new image object that is masked with the specified mask color.
 *
 *  @param maskColor The color value for the mask. This value must not be `nil`.
 *
 *  @return A new image object masked with the specified color.
 */
- (UIImage *)zhc_imageMaskedWithColor:(UIColor *)maskColor;


/**
 *  @return The compact message bubble image.
 *
 *  @discussion This is the default bubble image used by `ZHCMessagesBubbleImageFactory`.
 */
+ (UIImage *)zhc_getBubbleCommpactImage;

/**
 *  @return The default typing indicator image.
 */
+ (UIImage *)zhc_defaultTypingIndicatorImage;

/**
 *  @return The default play icon image.
 */
+ (UIImage *)zhc_defaultPlayImage;

/**
 *  @return The default pause icon image.
 */
+ (UIImage *)zhc_defaultPauseImage;

/**
 *  @return The default input toolbar accessory image.
 */
+ (UIImage *)zhc_defaultAccessoryImage;

@end
