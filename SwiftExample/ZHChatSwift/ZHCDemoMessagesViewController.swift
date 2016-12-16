//
//  ZHCDemoMessagesViewController.swift
//  ZHChatSwift
//
//  Created by aimoke on 16/12/16.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import UIKit
import ZHChat

class ZHCDemoMessagesViewController: ZHCMessagesViewController {
    
    var demoData: ZHModelData = ZHModelData.init();
    var presentBool: Bool = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demoData.loadMessages();
        self.title = "ZHCMessages";
        if self.automaticallyScrollsToMostRecentMessage {
            self.scrollToBottom(animated: false);
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if self.presentBool {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action:#selector(closePressed))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func closePressed() -> Void {
        self.navigationController?.dismiss(animated: true, completion: nil);
    }
    
    // MARK: ZHCMessagesTableViewDataSource
    
    override func senderDisplayName() -> String {
        return kZHCDemoAvatarDisplayNameJobs;
    }
    
    override func  senderId() -> String {
        return kZHCDemoAvatarIdJobs;
    }
    
    override func  tableView(_ tableView: ZHCMessagesTableView, messageDataForCellAt indexPath: IndexPath) -> ZHCMessageData {
        return self.demoData.messages.object(at: indexPath.row) as! ZHCMessageData;
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.demoData.messages.removeObject(at: indexPath.row);
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, messageBubbleImageDataForCellAt indexPath: IndexPath) -> ZHCMessageBubbleImageDataSource? {
        /**
         *  You may return nil here if you do not want bubbles.
         *  In this case, you should set the background color of your TableView view cell's textView.
         *
         *  Otherwise, return your previously created bubble image data objects.
         */
        let message: ZHCMessage = self.demoData.messages.object(at: indexPath.row) as! ZHCMessage;
        if message.isMediaMessage {
            print("is mediaMessage");
        }
        if message.senderId == self.senderId() {
            return self.demoData.outgoingBubbleImageData;
        }
        return self.demoData.incomingBubbleImageData;
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, avatarImageDataForCellAt indexPath: IndexPath) -> ZHCMessageAvatarImageDataSource? {
        /**
         *  Return your previously created avatar image data objects.
         *
         *  Note: these the avatars will be sized according to these values:
         *
         *  Override the defaults in `viewDidLoad`
         */
        
        let message: ZHCMessage = self.demoData.messages.object(at: indexPath.row) as! ZHCMessage;
        return self.demoData.avatars.object(forKey: message.senderId) as! ZHCMessageAvatarImageDataSource?;
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.row%3==0) {
            let message: ZHCMessage = (self.demoData.messages.object(at: indexPath.row) as? ZHCMessage)!;
            return ZHCMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date);
            
        }
        return nil;
        
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message: ZHCMessage = self.demoData.messages.object(at: indexPath.row) as! ZHCMessage;
        if message.senderId == self.senderId(){
            return nil;
        }
        if (indexPath.row-1)>0 {
            let preMessage: ZHCMessage = self.demoData.messages.object(at: indexPath.row-1) as! ZHCMessage;
            if preMessage.senderId == message.senderId{
                return nil;
            }
        }
        return NSAttributedString.init(string: message.senderDisplayName);
    }
    
    
    override func tableView(_ tableView: ZHCMessagesTableView, attributedTextForCellBottomLabelAt indexPath: IndexPath) -> NSAttributedString? {
        return nil;
    }
    
    // MARK: Adjusting cell label heights
    
    override func tableView(_ tableView: ZHCMessagesTableView, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        var labelHeight = 0.0;
        if indexPath.row%3 == 0 {
            labelHeight = Double(kZHCMessagesTableViewCellLabelHeightDefault);
        }
        return CGFloat(labelHeight);
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        var labelHeight = kZHCMessagesTableViewCellLabelHeightDefault;
        let currentMessage: ZHCMessage = self.demoData.messages.object(at: indexPath.row) as! ZHCMessage;
        if currentMessage.senderId==self.senderId(){
            labelHeight = 0.0;
        }
        if ((indexPath.row - 1) > 0){
            let previousMessage: ZHCMessage = self.demoData.messages.object(at: indexPath.row-1) as! ZHCMessage;
            if (previousMessage.senderId == currentMessage.senderId) {
                labelHeight = 0.0;
            }
        }
        return CGFloat(labelHeight);
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, heightForCellBottomLabelAt indexPath: IndexPath) -> CGFloat {
        let string: NSAttributedString? = self.tableView(tableView, attributedTextForCellBottomLabelAt: indexPath);
        if ((string) != nil) {
            return CGFloat(kZHCMessagesTableViewCellSpaceDefault);
        }else{
            return 0.0;
        }
    }
    
    //MARK: ZHCMessagesTableViewDelegate
    override func tableView(_ tableView: ZHCMessagesTableView, didTapAvatarImageView avatarImageView: UIImageView, at indexPath: IndexPath) {
        super.tableView(tableView, didTapAvatarImageView: avatarImageView, at: indexPath);
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, didTapMessageBubbleAt indexPath: IndexPath) {
        super.tableView(tableView, didTapMessageBubbleAt: indexPath);
    }
    
    override func tableView(_ tableView: ZHCMessagesTableView, performAction action: Selector, forcellAt indexPath: IndexPath, withSender sender: Any?) {
        super.tableView(tableView, performAction: action, forcellAt: indexPath, withSender: sender);
    }
    
    //MARK:TableView datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demoData.messages.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ZHCMessagesTableViewCell = super.tableView(tableView, cellForRowAt: indexPath) as! ZHCMessagesTableViewCell;
        self.configureCell(cell, atIndexPath: indexPath);
        return cell;
    }
    
    //MARK:Configure Cell Data
    func configureCell(_ cell: ZHCMessagesTableViewCell, atIndexPath indexPath: IndexPath) -> Void {
        let message: ZHCMessage = self.demoData.messages.object(at: indexPath.row) as! ZHCMessage;
        if !message.isMediaMessage {
            if (message.senderId == self.senderId()) {
                cell.textView?.textColor = UIColor.black;
            }else{
                cell.textView?.textColor = UIColor.white;
            }
        }
    }
    
    //MARK: Messages view controller
    
    override func didPressSend(_ button: UIButton?, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        /**
         *  Sending a message. Your implementation of this method should do *at least* the following:
         *
         *  1. Play sound (optional)
         *  2. Add new id<ZHCMessageData> object to your data source
         *  3. Call `finishSendingMessage`
         */
        let message: ZHCMessage = ZHCMessage.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text);
        self.demoData.messages.add(message);
        self.finishSendingMessage(animated: true);
        
    }
    
    //MARK: ZHCMessagesInputToolbarDelegate
    override func messagesInputToolbar(_ toolbar: ZHCMessagesInputToolbar, sendVoice voiceFilePath: String, seconds senconds: TimeInterval) {
        let audioData: NSData = try!NSData.init(contentsOfFile: voiceFilePath);
        let audioItem: ZHCAudioMediaItem = ZHCAudioMediaItem.init(data: audioData as Data);
        let audioMessage: ZHCMessage = ZHCMessage.init(senderId: self.senderId(), displayName: self.senderDisplayName(), media: audioItem);
        self.demoData.messages.add(audioMessage);
        self.finishSendingMessage(animated: true);
    }
    
    //MARK: ZHCMessagesMoreViewDelegate
    override func messagesMoreView(_ moreView: ZHCMessagesMoreView, selectedMoreViewItemWith index: Int) {
        switch index {
        case 0://Camera
            self.demoData.addVideoMediaMessage();
            self.messageTableView?.reloadData();
            self.finishSendingMessage();
        case 1://Photos
            self.demoData.addPhotoMediaMessage();
            self.messageTableView?.reloadData();
            self.finishSendingMessage();
        case 2:
            self.demoData.addLocationMediaMessageCompletion {
                self.messageTableView?.reloadData();
                self.finishSendingMessage();
            }
            
        default:
            break;
            
        }
    }
    
    //MARK: ZHCMessagesMoreViewDataSource
    override func messagesMoreViewTitles(_ moreView: ZHCMessagesMoreView) -> [Any] {
        return ["Camera","Photos","Location"];
    }
    
    override func messagesMoreViewImgNames(_ moreView: ZHCMessagesMoreView) -> [Any] {
        return ["chat_bar_icons_camera","chat_bar_icons_pic","chat_bar_icons_location"]
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
