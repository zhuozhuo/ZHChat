//
//  ZHPhotoItem.m
//  ImcoWatch
//
//  Created by aimoke on 16/10/28.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHPhotoItem.h"
#import "ZHCMessagesMediaPlaceholderView.h"
#import "ZHCMessagesMediaViewBubbleImageMasker.h"
#import <MobileCoreServices/UTCoreTypes.h>


#define IndicatorViewTag 401
#define downLoadImgViewTag 400
#define upLoadImgViewTag 402

@interface ZHPhotoItem()
@property (strong, nonatomic) UIImageView *cachedImageView;
@end
@implementation ZHPhotoItem

#pragma mark - Initialization
-(instancetype)initWithImage:(UIImage *)image withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        _image = [image copy];
        _imgUrl = nil;
        _cachedImageView = nil;
        _imgWidth = width;
        _imgHeight = height;
    }
    return self;
}

-(instancetype)initWithImgUrl:(NSString *)url withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        _image = nil;
       
        _cachedImageView = nil;
        _imgWidth = width;
        _imgHeight = height;
        CGSize size = [self mediaViewDisplaySize];
        [self getImgWithUrl:url WithImgSize:CGSizeMake(size.width, size.height)];
    }
    return self;
}


-(void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedImageView = nil;
}

#pragma mark - Settters
-(void)setImage:(UIImage *)image
{
    _image = [image copy];
    _cachedImageView = nil;
}

-(void)setImgWidth:(CGFloat)imgWidth
{
    _imgWidth = imgWidth;
    _cachedImageView = nil;
}

-(void)setImgHeight:(CGFloat)imgHeight
{
    _imgHeight = imgHeight;
    _cachedImageView = nil;
}

-(void)setImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    _cachedImageView = nil;
}

-(void)setStatus:(NSInteger)status
{
    _status = status;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reSetCacheImageView];
    });
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedImageView = nil;
}


#pragma mark - ZHCMessageMediaData protocol

- (UIView *)mediaView
{
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if (self.cachedImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        BOOL outgoing = self.appliesMediaViewMaskAsOutgoing;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
        imageView.frame = CGRectMake(0, 0, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [ZHCMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:outgoing];
        self.cachedImageView = imageView;
    }
    [self reSetCacheImageView];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    return self.cachedImageView;
}


-(void)reSetCacheImageView
{
    if (_cachedImageView) {
        switch (_status) {
            case STATUS_SUCCEED:{
                if (_image) {
                    for (UIView *view in [_cachedImageView subviews]) {
                        [view removeFromSuperview];
                    }
                    _cachedImageView.image = _image;
                }
            }
                break;
            case STATUS_DOWNLOADFAIL:{
                if (![_cachedImageView viewWithTag:downLoadImgViewTag]) {
                    CGSize size = [self mediaViewDisplaySize];
                    UIImage *icon = [UIImage imageNamed:@"photomediaitem_download"];
                    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
                    CGFloat ypos = (size.height - icon.size.height) / 2;
                    CGFloat xpos = (size.width - icon.size.width) / 2;
                    iconView.frame = CGRectMake(xpos, ypos, icon.size.width, icon.size.height);
                    iconView.tag = downLoadImgViewTag;
                    [self.cachedImageView addSubview:iconView];

                }
            }
                break;
            case STATUS_UPLOADINGFAIL:{
                if (![_cachedImageView viewWithTag:upLoadImgViewTag]) {
                    CGSize size = [self mediaViewDisplaySize];
                    UIImage *icon = [UIImage imageNamed:@"ibd_message_failed"];
                    UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
                    CGFloat ypos = (size.height - icon.size.height) / 2;
                    CGFloat xpos = (size.width - icon.size.width) / 2;
                    iconView.frame = CGRectMake(xpos, ypos, icon.size.width, icon.size.height);
                    iconView.tag = upLoadImgViewTag;
                    [self.cachedImageView addSubview:iconView];
                    
                }

            }
                break;
            case STATUS_UPLOADING:{
                if (!([_cachedImageView viewWithTag:IndicatorViewTag])) {
                    CGSize size = [self mediaViewDisplaySize];
                    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    indicatorView.center = CGPointMake(size.width/2.0, size.height/2.0);
                    indicatorView.tag = IndicatorViewTag;
                    [indicatorView startAnimating];
                    [self.cachedImageView addSubview:indicatorView];
                   
                }
            }
                break;
            case STATUS_DOWNLOADING:{
                if (!([_cachedImageView viewWithTag:IndicatorViewTag])) {
                    CGSize size = [self mediaViewDisplaySize];
                    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    indicatorView.center = CGPointMake(size.width/2.0, size.height/2.0);
                    indicatorView.tag = IndicatorViewTag;
                    [indicatorView startAnimating];
                    [self.cachedImageView addSubview:indicatorView];
                    
                }
            }
                break;
                
            default:
                break;
        }
    }
}


-(CGSize)mediaViewDisplaySize
{
    NSAssert(_imgWidth >0, @"imgWidth must more than 0");
    NSInteger width = 210;
    if (_imgWidth < 210) {
        width = _imgWidth;
    }
    NSInteger height = width/_imgWidth * _imgHeight;
    if (height == 0) {
        height = 100;
    }
    if (height > 350) {//Height restrictions
        height = 350;
    }
    return CGSizeMake(width, height);
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

- (NSString *)mediaDataType
{
    return (NSString *)kUTTypeJPEG;
}


- (id)mediaData
{
    return UIImageJPEGRepresentation(self.image, 1);
}


#pragma mark - NSObject

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSUInteger)hash
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return super.hash ^ self.image.hash;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)description
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return [NSString stringWithFormat:@"<%@: image=%@, width=%f, height=%f,imageUrl:%@ appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.image, _imgWidth, _imgHeight,_imgUrl, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (instancetype)initWithCoder:(NSCoder *)aDecoder
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
        _imgUrl = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(imgUrl))];
        _imgWidth = [aDecoder decodeFloatForKey:NSStringFromSelector(@selector(imgWidth))];
        _imgHeight = [aDecoder decodeFloatForKey:NSStringFromSelector(@selector(imgHeight))];
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder *)aCoder
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
    [aCoder encodeObject:self.imgUrl forKey:NSStringFromSelector(@selector(imgUrl))];
    [aCoder encodeFloat:self.imgWidth forKey:NSStringFromSelector(@selector(imgWidth))];
    [aCoder encodeFloat:self.imgHeight forKey:NSStringFromSelector(@selector(imgHeight))];
}

#pragma mark - NSCopying

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (instancetype)copyWithZone:(NSZone *)zone
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (_image) {
        ZHPhotoItem *copy = [[[self class] allocWithZone:zone] initWithImage:_image withWidth:_imgWidth withHeight:_imgHeight];
        copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
        return copy;
    }else{
        ZHPhotoItem *copy = [[[self class] allocWithZone:zone]initWithImgUrl:_imgUrl withWidth:_imgWidth withHeight:_imgHeight];
        copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
        return copy;

    }
}


#pragma mark - getImage
-(void)getImgWithUrl:(NSString *)imgUrl WithImgSize:(CGSize)imgSize
{
    self.status = STATUS_DOWNLOADING;
    NSURL *url = [NSURL URLWithString:imgUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:6.0];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response,NSError *error){
        if (error) {
            self.status = STATUS_DOWNLOADFAIL;
        }else{
            _image = [UIImage imageWithData:data];
            self.status = STATUS_SUCCEED;
        }
    }];
    [dataTask resume];
}

@end
