//
//  DemoModelData.swift
//  ChartDemo
//
//  Created by Andrew on 16/7/2.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import JSQSystemSoundPlayer
import JSQMessagesViewController


let kJSQDemoAvatarDisplayNameSquires = "Jesse Squires";
let kJSQDemoAvatarDisplayNameCook = "Tim Cook";
let kJSQDemoAvatarDisplayNameJobs = "Jobs";
let kJSQDemoAvatarDisplayNameWoz = "Steve Wozniak";

let  kJSQDemoAvatarIdSquires = "053496-4509-289";
let  kJSQDemoAvatarIdCook = "468-768355-23123";
let  kJSQDemoAvatarIdJobs = "707-8956784-57";
let  kJSQDemoAvatarIdWoz = "309-41802-93823";

class DemoModelData: NSObject {

    /// 消息的集合
    var messages:NSMutableArray = NSMutableArray()
    var avatars:NSDictionary!
    
    //输出消息人的头像
    var outgoingBubbleImageData:JSQMessagesBubbleImage!
    //接收消息人的头像
    var incomingBubbleImageData:JSQMessagesBubbleImage!
    
    var users:[String:AnyObject]!
    
    override init() {
        super.init()
        
        loadFakeMessages()
        
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */
        
        let cookImage = UIImage(named: "demo_avatar_cook")
        let jobsImage = UIImage(named: "demo_avatar_jobs")
        let wozImg = UIImage(named: "demo_avatar_woz")
        
        
        let avatarFactory = JSQMessagesAvatarImageFactory()
        let jsqImage = JSQMessagesAvatarImage(avatarImage: jobsImage, highlightedImage: jobsImage, placeholderImage: jobsImage)
        
         let cookImageJSQ = JSQMessagesAvatarImage(avatarImage: cookImage, highlightedImage: cookImage, placeholderImage: cookImage)
        
         let jobsImageJSQ = JSQMessagesAvatarImage(avatarImage: jobsImage, highlightedImage: jobsImage, placeholderImage: jobsImage)
        
         let wozImgJSQ = JSQMessagesAvatarImage(avatarImage: wozImg, highlightedImage: wozImg, placeholderImage: wozImg)
        
        
        

        self.avatars = [ kJSQDemoAvatarIdSquires : jsqImage,
            kJSQDemoAvatarIdCook : cookImageJSQ,
            kJSQDemoAvatarIdJobs : jobsImageJSQ,
            kJSQDemoAvatarIdWoz : wozImgJSQ ];
        
        
        self.users = [kJSQDemoAvatarIdJobs : kJSQDemoAvatarDisplayNameJobs,
            kJSQDemoAvatarIdCook : kJSQDemoAvatarDisplayNameCook,
            kJSQDemoAvatarIdWoz : kJSQDemoAvatarDisplayNameWoz,
            kJSQDemoAvatarIdSquires : kJSQDemoAvatarDisplayNameSquires ];
        
        let bubbleFactory:JSQMessagesBubbleImageFactory = JSQMessagesBubbleImageFactory()
        
        self.outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        self.incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }
    
    /**
     添加图片消息
     */
    func addPhotoMediaMessage() -> Void {
        
        let photoItem = JSQPhotoMediaItem(image:UIImage(named: "goldengate"))
        
        let msg = JSQMessage(senderId: kJSQDemoAvatarIdSquires, displayName: kJSQDemoAvatarDisplayNameSquires, media: photoItem)
        
        self.messages.addObject(msg)
        
    }
    /**
     添加视频消息
     */
    func addVideoMediaMessage() -> Void {
        var sample = NSBundle.mainBundle().pathForResource("jsq_messages_sample", ofType: "m4a")!
        
        let audioData = NSData(contentsOfFile: sample)
        let mediaItem = JSQAudioMediaItem(data: audioData)
        
        let audioMessage = JSQMessage(senderId: kJSQDemoAvatarIdSquires, displayName: kJSQDemoAvatarDisplayNameSquires, media: mediaItem)
        self.messages.addObject(audioMessage)
        
    }
    /**
     添加音频消息
     */
    func addAudioMediaMessage() -> Void {
        
    }
    
    /**
     加载一些历史消息
     */
    func loadFakeMessages() -> Void {
        
        let msg1 = JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate.distantPast(),text: "欢迎使用JSQMessage框架")
        
        let msg2 = JSQMessage(senderId: kJSQDemoAvatarIdWoz, senderDisplayName: kJSQDemoAvatarDisplayNameWoz, date: NSDate.distantPast(), text: "它是简单的，容易使用的")
        
        let msg3 = JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate.distantPast(), text: "It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com.")
        
        let msg4 = JSQMessage(senderId: kJSQDemoAvatarIdJobs, senderDisplayName: kJSQDemoAvatarDisplayNameJobs, date: NSDate.distantPast(), text: "JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better.")
        
        let msg5 =  JSQMessage(senderId: kJSQDemoAvatarIdCook, senderDisplayName: kJSQDemoAvatarDisplayNameCook, date: NSDate(), text: "It is unit-tested, free, open-source, and documented")
        
        let msg6 =  JSQMessage(senderId: kJSQDemoAvatarIdSquires, senderDisplayName: kJSQDemoAvatarDisplayNameSquires, date: NSDate(), text: "现在赶紧使用吧")
        messages.addObject(msg1)
        messages.addObject(msg2)
        messages.addObject(msg3)
        messages.addObject(msg4)
        messages.addObject(msg5)
        messages.addObject(msg6)
        
        self.addPhotoMediaMessage()
        self.addAudioMediaMessage()
        
    }
    
    
    
    
}
