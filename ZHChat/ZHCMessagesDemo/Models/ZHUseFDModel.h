//
//  ZHUseFDModel.h
//  testAutoCalculateCellHeight
//
//  Created by aimoke on 16/8/3.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHUseFDModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *identifier;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
