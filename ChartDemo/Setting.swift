//
//  Setting.swift
//  ChartDemo
//
//  Created by Andrew on 16/7/2.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit

let kSettingExtraMessages = "kSettingExtraMessages";
/// 较长的消息
let kSettingLongMessage = "kSettingLongMessage";
/// 设置是否清空消息
let kSettingEmptyMessages = "kSettingEmptyMessages";
/// 消息展示的时候时候具有弹簧效果
let kSettingSpringiness = "kSettingSpringiness";
/// 接受消息人的头像
let kSettingIncomingAvatar = "kSettingIncomingAvatar";
/// 发送消息人的头像
let kSettingOutgoingAvatar = "kSettingOutgoingAvatar";


extension NSUserDefaults{
    class func saveExtraMessagesSetting(value:Bool) -> Void {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingExtraMessages)
    }
    
    class func extraMessagesSetting() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingExtraMessages)
    }
    
    
   class func saveLongMessageSetting(value:Bool) -> Void {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingLongMessage)
    }
    
   class func longMessageSetting() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingLongMessage)
    }
    
   class func saveEmptyMessagesSetting(value:Bool) -> Void {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingEmptyMessages)
    }
    
   class func emptyMessagesSetting() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingEmptyMessages)
    }
    
    
   class func saveSpringinessSetting(value:Bool) -> Void {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingSpringiness)
    }
    
   class  func springinessSetting() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingSpringiness)

    }
    
   class func saveOutgoingAvatarSetting(value:Bool) -> Void {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingOutgoingAvatar)
    }
    
   class func outgoingAvatarSetting() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingOutgoingAvatar)
    }

   class func saveIncomingAvatarSetting(value:Bool) -> Void {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: kSettingIncomingAvatar)
    }
    
   class func incomingAvatarSetting() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(kSettingIncomingAvatar)

    }
    
    
}

class Setting: NSUserDefaults {

    
}
