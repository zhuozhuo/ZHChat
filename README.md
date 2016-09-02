##ZHChat
[ZHChat](https://github.com/zhuozhuo/ZHChat) is a free open source chat UI components, support for sending voice, pictures, words, expressions, location, video messages. ZHChat can help developers to quickly integrate IM service, easy chat, provides totally free licensing agreement, support for secondary development. Welcome to pull Request.
![Screenshot0][img0] &nbsp;&nbsp; ![Screenshot1][img1] &nbsp;&nbsp;

![Screenshot2][img2] &nbsp;&nbsp; ![Screenshot3][img3]
![Screenshot4][img4] &nbsp;&nbsp; ![Gif][gif0] 

##Features
* Interface to imitate Apple with a messaging application interface.
* Contains text, pictures, voice, location, sends a video message features.
* Excludes chat interface is based on a UITableView, easier to understand the entire UI framework。



## Design Goals
Easy integrated chat feature.


## Requirements

* iOS 7.1+
* ARC



## Usage
### [CocoaPods](https://cocoapods.org/) (recommended)

pod 'ZHChat', '~> 0.1.4'

### 复制文件夹ZHCMessagesViewController至你的工程中

## Getting Started
*Getting started guide for ZHChat*

```objective-c
#import <ZHChat/ZHCMessages.h> // import all the things
```

* ** Demo Project**
  * There's a sweet demo project: 'ZHChat.xcworkspace'
    * Run 'pod install' first
    
* **Customizing**
  * The demo project is well-commented. Please use this as a guide.
  
  * **View Controller**
  * Subclass `ZHCMessagesViewController`.
  * Implement the required methods in the `ZHCMessagesTableViewDataSource` protocol.
  * Implement the required methods in the `ZHCMessagesTableViewDelegate` protocol.
  * Implement the required methods in the `ZHCMessagesMoreViewDelegate` protocol.
  * Implement the required methods in the `ZHCMessagesMoreViewDataSource` protocol.
  * Implement the required methods in the `ZHCEmojiViewDelegate` protocol.  
  * Implement the required methods in the `ZHCMessagesInputToolbarDelegate` protocol.

  * Set your `senderId` and `senderDisplayName`. These properties correspond to the methods found in `ZHCMessageData` and determine which messages are incoming or outgoing.

* **Avatar Model**
  * Your avatar model objects should conform to the `ZHCMessageBubbleImageDataSource` protocol.
  * However, you may use the provided `ZHCMessagesAvatarImage` class.
  * Also see `ZHCMessagesAvatarImageFactory` for easily generating custom avatars.

* **Message Bubble Model**
  * Your message bubble model objects should conform to the `ZHCMessageAvatarImageDataSource` protocol.
  * However, you may use the provided `ZHCMessagesAvatarImage` class.
  * Also see `ZHCMessagesBubbleImageFactory` and `UIImage+ZHCMessages` for easily generating custom bubbles.
  
* **Message Model**
  * Your message model objects should conform to the `ZHCMessageData` protocol.
  * However, you may use the provided `ZHCMessage` class.
  
  
* **Media Attachment Model**
  * Your media attachment model objects should conform to the `ZHCMessageMediaData` protocol.
  * However, you may use the provided classes: `ZHCAudioMediaItem', `ZHCLocationMediaItem`, `ZHCPhotoMediaItem`.
  * Creating your own custom media items is easy! Simply follow the pattern used by the built-in media types.
  * Also see `ZHCMessagesMediaPlaceholderView` for masking your custom media views as message bubbles.

* **More Module**
  * You can see 'ZHCMessagesMoreView' .
  * Implement the required methods in the `ZHCMessagesMoreViewDelegate` protocol.
  * Implement the required methods in the `ZHCMessagesMoreViewDataSource` protocol.
 
* **Audio Module**
  * You can see 'ZHCMessagesVoiceRecorder','ZHCMessagesAudioProgressHUD' .
  * 'ZHCMessagesAudioProgressHUD' is a recording voice animation view.
  * 'ZHCMessagesVoiceRecorder' is recorder. It implement the required methods in the `ZHCMessagesVoiceDelegate` protocol.
  
* **Emoji Module**
  * You can see 'ZHCMessagesEmojiView' .
  * Implement the required methods in the `ZHCEmojiViewDelegate` protocol.
  * The emoji resource in "ZHCEmojiList.plist".


## To Do
* Increased adaptation work rotation and horizontal screen adaptation function。


### Thanks
Thaks [Jesse Squires](https://github.com/jessesquires/JSQMessagesViewController) Structures and resources drawn on JSQMessagesViewController.

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).



[img0]:http://ac-unmt7l5d.clouddn.com/9c9a4040dce03adb.PNG
[img1]:http://ac-unmt7l5d.clouddn.com/997f7a7a767fa873.PNG
[img2]:http://ac-unmt7l5d.clouddn.com/1f84fb1e70b3753e.PNG
[img3]:http://ac-unmt7l5d.clouddn.com/6a9a2c2a8dcb899f.PNG
[img4]:http://ac-unmt7l5d.clouddn.com/b13d915b9c91eb1a.PNG

[gif0]:http://ac-unmt7l5d.clouddn.com/1e394395d85171a1.gif
