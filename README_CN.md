#ZHChat
[ZHChat](https://github.com/zhuozhuo/ZHChat)是一个开源的聊天组件,能够帮助iOS开发者快速集成开发即时聊天模块。支持 声音，视频，图片，文字，表情，地理位置消息模块，易扩展，支持二次开发.Welcome to pull Request.

 <div align="center">![Gif][gif0]</div>


##Features
1. 界面模仿苹果消息应用。
2. 支持高度自定义,例如聊天气泡自定义,聊天消息模块自定义。
3. 支持的消息种类满足大部分及时通讯需求。
4. 基于苹果原生UITableView方便理解整个UI架构，二次开发成本低。
5. 支持Objective-C 和 Swift 两种语言。

## Design Goals
简单快捷集成聊天UI框架。


## Requirements
* iOS 7.0+
* ARC

## Usage
### [CocoaPods](https://cocoapods.org/) (recommended)

pod 'ZHChat', '~> 0.2.2'

### *拷贝整个ZHCMessagesViewController文件夹至你工程中。(二次开发最佳选择方式)*

## Getting Started

导入头所有ZHChat头文件：


```objective-c
#import <ZHChat/ZHCMessages.h> // import all the things

```

## 关于Demo的使用

1. 下载整个工程。
2. 终端运行 `pod install` 或者 `pod update`

## 自定义消息模块
1. 继承 `ZHCMediaItem`类。
2. 实现 `ZHCMessageMediaData`协议中的方法:
* ` - (nullable UIView *)mediaView`//用于展示所有非文字的消息类型，例如图片，声音，视频，地理位置。这里你也可以自定义所有你想要的消息类型例如图片+文字组合。


* `-(CGSize)mediaViewDisplaySize`//用于确定mediaView消息视图的大小。这里你可以根据需求限定一个最大值或者最小值，也可以是固定的大小。




自定义时可以参考ZHCMediaItem,添加自己的新增的属性（例如网络下载资源链接）,和初始化方法,并实现前面介绍的两个接口即可。

这里重点提下关于网络下载资源，例如图片：你可以增加一个下载地址:`imgUrl` 然后实现一个有下载地址的初始化函数:

```
-(instancetype)initWithImgUrl:(NSString *)url
```

并实现多媒体展示视图接口：

```ob
- (UIView *)mediaView
{
    if (self.cachedImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [ZHCMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        self.cachedImageView = imageView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.cachedImageView = imageView;
                });
                
            }
           
        }];

    }
    
    return self.cachedImageView;
}
```

当然这只是很简单的例子：实际IM通讯中消息有很多状态:你需要根据不同的状态进行相应的显示,例如下载进度，上传进度，下载失败，上传失败，发送上传成功等等....

## 网络加载头像

需要在继承`ZHCMessagesViewController`的接口中进行操作：

```obj
- (nullable id<ZHCMessageAvatarImageDataSource>)tableView:(ZHCMessagesTableView *)tableView avatarImageDataForCellAtIndexPath:(NSIndexPath *)indexPath
```

这里你可以下载完成后刷新TableView即可。



## 消息点击事件

需要在继承`ZHCMessagesViewController`的接口中进行操作：

```obj
-(void)tableView:(ZHCMessagesTableView *)tableView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
```

你可以根据消息的类型进行相关操作，例如展示大图片，播放视频等等。



## 更多接口介绍请看工程中头文件的介绍。如果您在使用中遇到了什么疑问可以通过邮件或者在GitHub中新建Issue












[img0]: http://ac-unmt7l5d.clouddn.com/39fd9320ae6315b2.PNG
[img1]: http://ac-unmt7l5d.clouddn.com/e1ed619294a427cc.PNG
[img2]: http://ac-unmt7l5d.clouddn.com/051832e16b4a5df2.PNG
[gif0]: http://ac-unmt7l5d.clouddn.com/a2e173ec4d2ec3da.gif