# Getting Started
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
  * However, you may use the provided `JSQMessagesAvatarImage` class.
  * Also see `JSQMessagesAvatarImageFactory` for easily generating custom avatars.

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
  

  