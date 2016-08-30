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
#import "ZHCMessagesEmojiFactory.h"
#import "ZHCMessagesEmojiView.h"
#import "ZHCMessagesAudioProgressHUD.h"
#import "ZHCMessagesAudioPlayer.h"
#import "ZHCMessagesVoiceRecorder.h"



@interface ZHCTestViewController ()<ZHCMessagesVoiceDelegate>{
    ZHCMessagesVoiceRecorder *recorder;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) ZHCMessagesEmojiView *emojiView;

@end

@implementation ZHCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.modalPresentationCapturesStatusBarAppearance =NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    recorder = [[ZHCMessagesVoiceRecorder alloc]init];
    recorder.delegate = self;
   
    
    // Do any additional setup after loading the view from its nib.
}


-(void)initialSubViews
{
    if (!_emojiView) {
        [self.view addSubview:self.emojiView];
        _emojiView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view zhc_pinSubview:_emojiView toEdge:NSLayoutAttributeLeading withConstant:0.0f];
        [self.view zhc_pinSubview:_emojiView toEdge:NSLayoutAttributeTrailing withConstant:0.0f];
        [self.view zhc_pinSubview:_emojiView toEdge:NSLayoutAttributeBottom withConstant:0.0f];
        [_emojiView zhc_pinSelfToEdge:NSLayoutAttributeHeight withConstant:kZHCMessagesFunctionViewHeight];
    }
    
}


-(ZHCMessagesEmojiView *)emojiView
{
    if (!_emojiView) {
        _emojiView = [[ZHCMessagesEmojiView alloc]init];
    }
    return _emojiView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickAudioAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (!button.selected) {
         [ZHCMessagesAudioProgressHUD zhc_show];
        [recorder zhc_startRecording];
    }else{
        [ZHCMessagesAudioProgressHUD zhc_dismissWithMessage:nil];
        [recorder zhc_stopRecording];
    }
    button.selected = !button.selected;
    
}

#pragma mark - ZHCMessagesVoiceDelegate
- (void)zhc_voiceRecorded:(NSString *)recordPath length:(float)recordLength
{
    NSLog(@"finishRecorder");
    [[ZHCMessagesAudioPlayer shareVoicePlayer]playAudioWithUrl:[NSURL URLWithString:recordPath]];
    
}

- (void)zhc_failRecord
{
    
}


@end
