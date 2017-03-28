//
//  ZHCNetManager.h
//  ZHChat
//
//  Created by aimoke on 17/3/28.
//  Copyright © 2017年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHCPublicStucture.h"

@interface ZHCNetManager : NSObject<NSURLSessionDelegate>

@property (nonatomic, strong) NSMutableDictionary *finishBlocks;
@property (nonatomic, strong) NSMutableDictionary *progressBlocks;
@property (nonatomic, strong) NSURLSession *session;

+(ZHCNetManager *)shareZHCNetManager;

-(void)downLoadDataWithUrl:(NSString *)dataUrl withCachePolicy:(NSURLRequestCachePolicy)cachePolicy withProgress:(ZHProgressBlock)progressBlock withFinish:(ZHFinishBlock)finish;

@end
