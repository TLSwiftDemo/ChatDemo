//
//  ViewController.swift
//  ChartDemo
//
//  Created by Andrew on 16/7/2.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit
import JSQMessagesViewController



protocol JSQDemoViewControllerDelegate:NSObjectProtocol {
    func didDismissJSQDemoViewController(vc:ViewController) -> Void
}

class ViewController: JSQMessagesViewController,JSQMessagesComposerTextViewPasteDelegate {
    
    weak var delegateModal:JSQDemoViewControllerDelegate?
    var demoData:DemoModelData!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(closePressed(_:)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JSQMessage"
        self.inputToolbar.contentView.textView.pasteDelegate = self
        
        //加载我们自己的历史聊天消息
        self.demoData = DemoModelData()
        
        //可以自己设置头像尺寸
        if(NSUserDefaults.incomingAvatarSetting() == false){
          self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        }
        
        if(NSUserDefaults.outgoingAvatarSetting() == false){
          self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        }
        
        self.showLoadEarlierMessagesHeader = true
        
       let typeImg = UIImage.jsq_defaultTypingIndicatorImage()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: typeImg, style: .Bordered, target: self, action: #selector(receiveMessagePressed(_:)))
        
        
        
        //注册自定义的菜单为每个cell
        JSQMessagesCollectionViewCell.registerMenuAction(#selector(customAction(_:)))
        
        JSQMessagesCollectionViewCell.registerMenuAction(#selector(delete(_:)))
    }
    

  
    //MARK: - 收到消息
    func receiveMessagePressed(sender:UIBarButtonItem) -> Void {
        
    }
    
    /**
    关闭页面
     
     - parameter sender:
     */
    func closePressed(sender:UIBarButtonItem) -> Void {
        self.delegateModal?.didDismissJSQDemoViewController(self)
    }
    

    
    //MARK: -  JSQMessagesComposerTextViewPasteDelegate 
    
    func composerTextView(textView: JSQMessagesComposerTextView!, shouldPasteWithSender sender: AnyObject!) -> Bool {
        
        return true
    }
    
    
    //MARK: - UIcollectionView delegate
    /**
     弹出 copy/delete 等自定义菜单
     
     - parameter collectionView:
     - parameter action:         <#action description#>
     - parameter indexPath:      <#indexPath description#>
     - parameter sender:         <#sender description#>
     
     - returns:
     */
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        
        if(action == #selector(customAction(_:))){
           return true
        }
        
        return super.collectionView(collectionView, canPerformAction: action, forItemAtIndexPath: indexPath, withSender: sender)
    }
    
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
        if(action == #selector(customAction(_:))){
            
            self.customAction(sender!)
            return
        }
        
        super.collectionView(collectionView, performAction: action, forItemAtIndexPath: indexPath, withSender: sender)
    }
    
    //MARK: - Custom menu item
    func customAction(sender:AnyObject) -> Void {
        let alert = UIAlertController(title: "customAction", message: nil, preferredStyle: .Alert)
        
        
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - JSQMessages CollectionView DataSource
    func getSenderId() -> String {
        return kJSQDemoAvatarIdSquires
    }
    
    func getSenderDisplayName() -> String {
        return kJSQDemoAvatarDisplayNameSquires
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.demoData.messages[indexPath.item] as! JSQMessageData
    }
    
    /**
     执行删除消息
     
     - parameter collectionView: <#collectionView description#>
     - parameter indexPath:      <#indexPath description#>
     */
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.demoData.messages.removeObjectAtIndex(indexPath.item)
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        /**
         *  You may return nil here if you do not want bubbles.
         *  In this case, you should set the background color of your collection view cell's textView.
         *
         *  Otherwise, return your previously created bubble image data objects.
         */
        
        let message = self.demoData.messages[indexPath.item] as! JSQMessage
        
        if (message.senderId  == self.getSenderId()){
           return self.demoData.outgoingBubbleImageData
        }
        
        return self.demoData.incomingBubbleImageData
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = self.demoData.messages[indexPath.item] as! JSQMessage
        if(message.senderId == getSenderId()){
            if(NSUserDefaults.outgoingAvatarSetting()==false){
             return nil
            }
        }else{
            if(NSUserDefaults.incomingAvatarSetting() == false){
              return nil
            }
        }
        
        return self.demoData.avatars.objectForKey(message.senderId) as! JSQMessageAvatarImageDataSource
    }
    
    /**
     返回发送的时间
     
     - parameter collectionView: <#collectionView description#>
     - parameter indexPath:      <#indexPath description#>
     
     - returns: <#return value description#>
     */
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if(indexPath.item % 3 == 0){
         let message = self.demoData.messages[indexPath.item] as! JSQMessage
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        return nil
    }
    
    /**
     显示对方昵称
     
     - parameter collectionView: <#collectionView description#>
     - parameter indexPath:      <#indexPath description#>
     
     - returns: <#return value description#>
     */
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let message = self.demoData.messages[indexPath.item] as! JSQMessage
        if (message.senderId == self.getSenderId()){
         return nil
        }
        
        if(indexPath.item - 1 > 0){
         let previousMessage = self.demoData.messages[indexPath.item - 1] as! JSQMessage
            if(previousMessage.senderId == message.senderId){
             return nil
            }
        }
        
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    
    //MARK: - UICollectionView DataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.demoData.messages.count
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? JSQMessagesCollectionViewCell
        
        let msg = self.demoData.messages[indexPath.item] as! JSQMessage
        if msg.isMediaMessage == false{
            if msg.senderId == getSenderId(){
             cell!.textView.textColor = UIColor.blackColor()
            }else{
                cell!.textView.textColor = UIColor.whiteColor()
            }
            
            
            cell!.textView.linkTextAttributes = [ NSForegroundColorAttributeName : cell!.textView.textColor!];
        }
        
        
        return cell!
    }

}




