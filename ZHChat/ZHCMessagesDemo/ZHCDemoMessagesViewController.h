//
//  ZHCDemoMessagesViewController.h
//  ZHChat
//
//  Created by aimoke on 16/8/23.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCMessages.h"
#import "ZHCModelData.h"



@interface ZHCDemoMessagesViewController : ZHCMessagesViewController
@property (strong, nonatomic) ZHCModelData *demoData;
@property (assign, nonatomic) BOOL presentBool;
@end
