//
//  ZHCTestViewController.m
//  ZHChat
//
//  Created by aimoke on 16/8/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCTestViewController.h"
#import "UIImage+ZHCMessages.h"
#import "UIColor+ZHCMessages.h"
#import "UIView+ZHCMessages.h"
#import "ZHCMessagesToolbarButtonFactory.h"
#import "ZHCMessagesMoreItem.h"

#import "ZHCMessagesMoreView.h"
#import "ZHCMessagesCommonParameter.h"



@interface ZHCTestViewController ()<ZHCMessagesMoreViewDelegate,ZHCMessagesMoreViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *presButton;

@end

@implementation ZHCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.modalPresentationCapturesStatusBarAppearance =NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    ZHCMessagesMoreView *moreView = [[ZHCMessagesMoreView alloc]init];
    moreView.delegate = self;
    moreView.dataSource = self;
    moreView.translatesAutoresizingMaskIntoConstraints = NO;
    moreView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:moreView];
    
    [self.view zhc_pinSubview:moreView toEdge:NSLayoutAttributeLeading withConstant:0.0f];
    [self.view zhc_pinSubview:moreView toEdge:NSLayoutAttributeTrailing withConstant:0.0f];
    [self.view zhc_pinSubview:moreView toEdge:NSLayoutAttributeBottom withConstant:0.0f];
    [moreView zhc_pinSelfToEdge:NSLayoutAttributeHeight withConstant:kZHCMessagesFunctionViewHeight];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ZHCMessagesMoreViewDataSource
-(void)messagesMoreView:(ZHCMessagesMoreView *)moreView selectedMoreViewItemWithIndex:(NSInteger)index
{
    NSLog(@"clickItemIndex:%ld",index);
}

-(NSArray *)messagesMoreViewTitles:(ZHCMessagesMoreView *)moreView
{
    return @[@"照相",@"位置",@"图片"];
}

-(NSArray *)messagesMoreViewImgNames:(ZHCMessagesMoreView *)moreView
{
    return @[@"chat_bar_icons_camera",@"chat_bar_icons_location",@"chat_bar_icons_pic"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
