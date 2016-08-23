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

@interface ZHCTestViewController ()

@end

@implementation ZHCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.modalPresentationCapturesStatusBarAppearance =NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets=NO;

    UIImage *image = [[UIImage zhc_getBubbleCommpactImage] zhc_imageMaskedWithColor:[UIColor zhc_messagesBubbleGreenColor]];
    UIImage *newImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationUpMirrored];
    self.showImgView.image = newImage;
    
    
    UIView *testView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    
    testView.backgroundColor = [UIColor grayColor];
    
    UIImageView *testImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    testImgView.image = image;
    testImgView.backgroundColor = [UIColor redColor];
    [testView addSubview:testImgView];
    
    [self.view addSubview:testView];
    testView.translatesAutoresizingMaskIntoConstraints = NO;
     CGRect frame = CGRectMake(50, 100, 150, 150);
    [self.view zhc_pinFrameOfSubView:testView withFrame:frame];
    
    
    // Do any additional setup after loading the view from its nib.
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

@end
