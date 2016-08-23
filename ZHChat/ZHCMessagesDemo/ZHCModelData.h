//
//  ZHCModelData.h
//  ZHChat
//
//  Created by aimoke on 16/8/10.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHCMessages.h"
#import "ZHCLocationMediaItem.h"
@class ZHCPhotoMediaItem;



static NSString * const kZHCDemoAvatarDisplayNameCook = @"Tim Cook";
static NSString * const kZHCDemoAvatarDisplayNameJobs = @"Jobs";

static NSString * const kZHCDemoAvatarIdCook = @"468-768355-23123";
static NSString * const kZHCDemoAvatarIdJobs = @"707-8956784-57";


@interface ZHCModelData : NSObject
@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) NSDictionary *users;

@property (strong, nonatomic) ZHCMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) ZHCMessagesBubbleImage *incomingBubbleImageData;


- (void)addPhotoMediaMessage;
- (void)addLocationMediaMessageCompletion:(ZHCLocationMediaItemCompletionBlock)completion;
- (void)addVideoMediaMessage;
- (void)addAudioMediaMessage;

@end
