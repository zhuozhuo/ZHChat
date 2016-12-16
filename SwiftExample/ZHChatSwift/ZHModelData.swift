//
//  ZHModelData.swift
//  ZHChatSwift
//
//  Created by aimoke on 16/12/16.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import UIKit
import ZHChat

let kZHCDemoAvatarDisplayNameCook = "Tim Cook";
let kZHCDemoAvatarDisplayNameJobs = "Jobs";
let kZHCDemoAvatarIdCook = "468-768355-23123";
let kZHCDemoAvatarIdJobs = "707-8956784-57";

class ZHModelData: NSObject {
    
    var messages: NSMutableArray = [];
    var avatars: NSDictionary = [:];
    var users: NSDictionary = [:];
    
    var outgoingBubbleImageData: ZHCMessagesBubbleImage?;
    var incomingBubbleImageData: ZHCMessagesBubbleImage?;
    
    func loadMessages() -> Void {
        let avatarFactory: ZHCMessagesAvatarImageFactory = ZHCMessagesAvatarImageFactory.init(diameter: UInt(kZHCMessagesTableViewCellAvatarSizeDefault));
        let cookImage: ZHCMessagesAvatarImage = avatarFactory.avatarImage(with: UIImage.init(named: "demo_avatar_cook"))
        let jobsImage: ZHCMessagesAvatarImage = avatarFactory.avatarImage(with: UIImage.init(named: "demo_avatar_jobs"));
        avatars = [kZHCDemoAvatarIdCook : cookImage,kZHCDemoAvatarIdJobs : jobsImage];
        users = [kZHCDemoAvatarIdJobs : kZHCDemoAvatarDisplayNameJobs,kZHCDemoAvatarIdCook : kZHCDemoAvatarDisplayNameCook];
        let bubbleFactory: ZHCMessagesBubbleImageFactory = ZHCMessagesBubbleImageFactory.init();
        outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImage(with: UIColor.zhc_messagesBubbleBlue());
        incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImage(with: UIColor.zhc_messagesBubbleGreen());
        
        let filePath: String = Bundle.main.path(forResource: "data", ofType: "json")!;
        let data: NSData = try!NSData.init(contentsOfFile: filePath);
        let dic: NSDictionary = try!JSONSerialization.jsonObject(with: data as Data, options: []) as! NSDictionary;
        let array: NSArray = dic.object(forKey: "feed") as! NSArray;
        let muArray: NSMutableArray = [];
        for item in array {
            let model: ZHUserModel = ZHUserModel.init();
            model.initialDataWithDictionary(dic: item as! NSDictionary);
            muArray.add(model);
        }
        
        for i in 0 ..< muArray.count{
            let model: ZHUserModel = muArray.object(at: i) as! ZHUserModel;
            let avatarId: NSString?;
            let displayName: NSString?;
            if i%3 == 0{
                avatarId = kZHCDemoAvatarIdCook as NSString?;
                displayName = kZHCDemoAvatarDisplayNameCook as NSString?;
            }else{
                avatarId = kZHCDemoAvatarIdJobs as NSString?;
                displayName = kZHCDemoAvatarDisplayNameJobs as NSString?;
            }
            let message: ZHCMessage = ZHCMessage.init(senderId: avatarId as! String, displayName: displayName as! String, text: model.content!)
            messages.add(message);
        }
        
    }
    
    func addPhotoMediaMessage() -> Void {
        let photoItem = ZHCPhotoMediaItem.init(image: UIImage.init(named: "goldengate"));
        photoItem.appliesMediaViewMaskAsOutgoing = false;
        let photoMessage = ZHCMessage.init(senderId: kZHCDemoAvatarIdCook, displayName: kZHCDemoAvatarDisplayNameCook, media: photoItem);
        messages.add(photoMessage);
    }
    
    func addLocationMediaMessageCompletion(completion: @escaping ZHCLocationMediaItemCompletionBlock) -> Void {
        let ferryBuildingInSF: CLLocation = CLLocation.init(latitude: 22.610599, longitude: 114.030238);
        let locationItem = ZHCLocationMediaItem.init();
        locationItem.setLocation(ferryBuildingInSF, withCompletionHandler: completion);
        locationItem.appliesMediaViewMaskAsOutgoing = true;
        let locationMessage: ZHCMessage = ZHCMessage.init(senderId: kZHCDemoAvatarIdJobs, displayName: kZHCDemoAvatarDisplayNameJobs, media: locationItem);
        messages.add(locationMessage);
        
    }
    
    func addVideoMediaMessage() -> Void {
        let videoURL: NSURL = NSURL.fileURL(withPath: "file://") as NSURL;
        let videoItem: ZHCVideoMediaItem = ZHCVideoMediaItem.init(fileURL: videoURL as URL, isReadyToPlay: true);
        videoItem.appliesMediaViewMaskAsOutgoing = true;
        let videoMessage = ZHCMessage.init(senderId: kZHCDemoAvatarIdJobs, displayName: kZHCDemoAvatarDisplayNameJobs, media: videoItem);
        messages.add(videoMessage);
    }
    
    func addAudioMediaMessage() -> Void {
        let sample: NSString = Bundle.main.path(forResource: "zhc_messages_sample", ofType: "m4a")! as NSString;
        let audioData: NSData = try!NSData.init(contentsOfFile: sample as String);
        let audioItem: ZHCAudioMediaItem = ZHCAudioMediaItem.init(data: audioData as Data);
        audioItem.appliesMediaViewMaskAsOutgoing = true;
        let audioMessage: ZHCMessage = ZHCMessage.init(senderId: kZHCDemoAvatarIdCook, displayName: kZHCDemoAvatarDisplayNameCook, media: audioItem);
        messages.add(audioMessage);
    }
    
    

}
