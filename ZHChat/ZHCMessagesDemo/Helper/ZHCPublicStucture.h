//
//  ZHPublicStucture.h
//  ZHChat
//
//  Created by aimoke on 17/3/28.
//  Copyright © 2017年 zhuo. All rights reserved.
//

#ifndef ZHCPublicStucture_h
#define ZHCPublicStucture_h


#endif /* ZHCPublicStucture_h */

typedef void (^ZHFinishBlock)(BOOL successed,NSData *data, NSError *error);
typedef void (^ZHProgressBlock)(NSInteger progress, NSError  *error);

typedef NS_ENUM(NSInteger,ZHLoadStatus){
    STATUS_UPLOADING = 0,
    STATUS_DOWNLOADING = 1,
    STATUS_SUCCEED = 2,
    STATUS_UPLOADINGFAIL = 3,
    STATUS_DOWNLOADFAIL = 4,
};
