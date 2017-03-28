//
//  ZHCNetManager.m
//  ZHChat
//
//  Created by aimoke on 17/3/28.
//  Copyright © 2017年 zhuo. All rights reserved.
//

#import "ZHCNetManager.h"

@implementation ZHCNetManager

#pragma mark - Initial
+(ZHCNetManager *)shareZHCNetManager
{
    static ZHCNetManager *manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        manager = [[ZHCNetManager alloc]init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.progressBlocks = [NSMutableDictionary dictionary];
        self.finishBlocks = [NSMutableDictionary dictionary];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return self;
}


#pragma mark - Public Methods
-(void)downLoadDataWithUrl:(NSString *)dataUrl withCachePolicy:(NSURLRequestCachePolicy)cachePolicy withProgress:(ZHProgressBlock)progressBlock withFinish:(ZHFinishBlock)finish
{
    NSAssert(dataUrl !=nil, @"DownLoad Url can not is nil");
    [self.progressBlocks setObject:progressBlock forKey:dataUrl];
    [self.finishBlocks setObject:finish forKey:dataUrl];
    
   // NSURL *url = [NSURL URLWithString:dataUrl];
    
   

}

@end
