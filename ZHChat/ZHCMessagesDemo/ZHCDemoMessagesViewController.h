//
//  ZHCDemoMessagesViewController.h
//  ZHChat
//
//  Created by aimoke on 16/8/23.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCMessagesViewController.h"
#import "ZHCModelData.h"


@interface ZHCDemoMessagesViewController : ZHCMessagesViewController<UIActionSheetDelegate>
@property (strong, nonatomic) ZHCModelData *demoData;
@end
