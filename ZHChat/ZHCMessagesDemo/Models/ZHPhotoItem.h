//
//  ZHPhotoItem.h
//  ImcoWatch
//
//  Created by aimoke on 16/10/28.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCMediaItem.h"
#import "ZHCPublicStucture.h"


@interface ZHPhotoItem : ZHCMediaItem
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, assign) NSInteger status;
@property (copy, nonatomic, nullable) UIImage *image;
@property (copy, nonatomic, nullable) NSString *imgUrl;
@property (nonatomic) CGFloat imgWidth;
@property (nonatomic) CGFloat imgHeight;


- (instancetype)initWithImage:(UIImage *)image withWidth:(CGFloat)width withHeight:(CGFloat)height;

-(instancetype)initWithImgUrl:(NSString *)url withWidth:(CGFloat)width withHeight:(CGFloat)height;
NS_ASSUME_NONNULL_END

@end
