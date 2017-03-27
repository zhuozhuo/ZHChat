//
//  ZHUserModel.swift
//  ZHChatSwift
//
//  Created by aimoke on 16/12/15.
//  Copyright © 2016年 zhuo. All rights reserved.
//

import UIKit
import Foundation

class ZHUserModel: NSObject {
    var title: String?
    var content: String?
    var username: String?
    var time: String?
    var imageName: String?
    var identifier: String?
    
    
    func initialDataWithDictionary(dic: NSDictionary) -> Void {
        self.title = dic.object(forKey: "title") as! String?;
        self.content = dic.object(forKey: "content")as! String?;
        self.username = dic.object(forKey: "username")as! String?;
        self.time = dic.object(forKey: "time") as! String?;
        self.imageName = dic.object(forKey: "imageName") as! String?;
        self.identifier = uniqueIdentifier();
    }
    
    func uniqueIdentifier() -> String {
        let counter = 0;
        let identifier: String;
        identifier = NSString.localizedStringWithFormat("unique-id-%d", counter) as String;
        return identifier;
    }

}

