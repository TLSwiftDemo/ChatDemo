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
        
        
        if(self.delegateModal != nil){
        
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(closePressed(_:)))
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.collectionViewLayout.springinessEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JSQMessage"
        self.inputToolbar.contentView.textView.pasteDelegate = self
        
        
        //加载我们自己的历史聊天消息
        self.demoData = DemoModelData()
        
        self.senderId = getSenderId()
        self.senderDisplayName = getSenderDisplayName()
       
        
        
        //可以自己设置头像尺寸
        
         self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(50, 50)
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(50, 50)
//        if(NSUserDefaults.incomingAvatarSetting() == false){
//          self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
//        }
//        
//        if(NSUserDefaults.outgoingAvatarSetting() == false){
//          self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
//        }
        
        self.showLoadEarlierMessagesHeader = true
        
       let typeImg = UIImage.jsq_defaultTypingIndicatorImage()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: typeImg, style:UIBarButtonItemStyle.Plain, target: self, action: #selector(receiveMessagePressed(_:)))
        
        
        
        //注册自定义的菜单为每个cell
        JSQMessagesCollectionViewCell.registerMenuAction(#selector(customAction(_:)))
        
        JSQMessagesCollectionViewCell.registerMenuAction(#selector(delete(_:)))
    }
    //MARK: - Custom menu actions for cells
    
    override func didReceiveMenuWillShowNotification(notification: NSNotification!) {
        /**
         *  Display custom menu actions for cells.
         */
        let menu = notification.object as! UIMenuController
//        menu.menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];
        menu.menuItems = [UIMenuItem(title: "Custom Action", action: #selector(customAction(_:)))]
        
        
    }

  
    //MARK: - 收到消息
    func receiveMessagePressed(sender:UIBarButtonItem) -> Void {
     
        //显示 输入消息的时候 ... 三个点
        self.showTypingIndicator = !self.showTypingIndicator
        
    self.scrollToBottomAnimated(true)
        
        //拷贝最新的消息，现在到 new message
        var copyMessage = self.demoData.messages.lastObject as? JSQMessage
        
        if(copyMessage == nil){
         copyMessage = JSQMessage(senderId: kJSQDemoAvatarIdJobs, senderDisplayName: kJSQDemoAvatarDisplayNameJobs, date: NSDate(), text: "First received")
            
        }
        
        //允许typing indicator显示出来 主动滞后3秒
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
                                    Int64(2 * Double(NSEC_PER_SEC))) // 1

        var newMessage:JSQMessage?
        var newMediaAttachmentCopy:AnyObject?;
        var newMediaData:JSQMessageMediaData?
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            let userids = self.demoData.users.keys
            
            print("userids=\(userids)")
            
            let index = arc4random_uniform(UInt32(userids.count))
            let randomUserId = userids.first;
            
            
          
            
            if copyMessage!.isMediaMessage == true{
                
                
                let copyMediaData = copyMessage!.media
                
                if(copyMediaData is JSQVideoMediaItem ){
                    let videoItemCopy = copyMediaData as! JSQVideoMediaItem
                    videoItemCopy.appliesMediaViewMaskAsOutgoing = false
                    newMediaAttachmentCopy = videoItemCopy.fileURL
                    
                    /**
                     *  Reset video item to simulate "downloading" the video
                     */
                    videoItemCopy.fileURL = nil;
                    videoItemCopy.isReadyToPlay = false;
                    
                    newMediaData = videoItemCopy;
                }else if(copyMediaData is JSQAudioMediaItem){
                  let audioItemCopy = copyMediaData as! JSQAudioMediaItem
                    audioItemCopy.appliesMediaViewMaskAsOutgoing = false
                    newMediaAttachmentCopy = audioItemCopy.audioData
                    /**
                     *  Reset audio item to simulate "downloading" the audio
                     */
                    audioItemCopy.audioData = nil;
                    
                    newMediaData = audioItemCopy;
                }else if(copyMediaData is JSQPhotoMediaItem){
                  let photoItem = copyMediaData as! JSQPhotoMediaItem
                    photoItem.appliesMediaViewMaskAsOutgoing = false
                    newMediaAttachmentCopy = UIImage(CGImage: photoItem.image.CGImage!)
                    
                    photoItem.image = nil
                    newMediaData = photoItem
                }
                
                else{
                  print("出错了，不能识别")
                }
                
                newMessage = JSQMessage(senderId: kJSQDemoAvatarIdWoz, displayName: kJSQDemoAvatarDisplayNameJobs, media: newMediaData)
            }
            
            
            self.demoData.messages.addObject(newMessage!)
            self.finishReceivingMessageAnimated(true)
            /**
             *  Upon receiving a message, you should:
             *
             *  1. Play sound (optional)
             *  2. Add new id<JSQMessageData> object to your data source
             *  3. Call `finishReceivingMessage`
             */
            
            if (newMessage!.isMediaMessage){
                dispatch_after(popTime, dispatch_get_main_queue(), {
                    
                    if(newMediaData is JSQPhotoMediaItem){
                    
                      let photoItem = newMediaData as! JSQPhotoMediaItem
                      photoItem.image = newMediaAttachmentCopy as? UIImage
                        self.collectionView.reloadData()
                        
                    }else if newMediaData is JSQVideoMediaItem{
                    
                         let vedioItem = newMediaData as? JSQVideoMediaItem
                        vedioItem?.fileURL = newMediaAttachmentCopy as! NSURL
                        vedioItem?.isReadyToPlay = true
                        self.collectionView.reloadData()
                    }else if newMediaData is JSQAudioMediaItem{
                       let audioItem = newMediaData as! JSQAudioMediaItem
                        audioItem.audioData = newMediaAttachmentCopy as? NSData
                        self.collectionView.reloadData()
                        
                    }else{
                      print("解析消息出错了")
                    }
                })
            }
            
        
        }
        
    }
    
    /**
    关闭页面
     
     - parameter sender:
     */
    func closePressed(sender:UIBarButtonItem) -> Void {
        self.delegateModal?.didDismissJSQDemoViewController(self)
    }
    
    //MARK: - JSQMessagesViewController method overrides
    
    /**
     点击了发送按钮
     
     - parameter button:            发送消息的按钮
     - parameter text:              文本消息
     - parameter senderId:          发送者的Id
     - parameter senderDisplayName: 发送者的名字
     - parameter date:              日期
     */
    override func didPressSendButton(button: UIButton!,
                                     withMessageText text: String!,
                                                     senderId: String!, senderDisplayName: String!, date: NSDate!) {
        /**
         *  Sending a message. Your implementation of this method should do *at least* the following:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishSendingMessage`
         */
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.demoData.messages.addObject(message)
        
        self.finishSendingMessageAnimated(true)
        
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        self.inputToolbar.contentView.textView.resignFirstResponder()
        
        let actionSheet = UIAlertController(title: "send Media", message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (Action) in
            self.inputToolbar.contentView.textView.becomeFirstResponder()
        }
        let photoAction = UIAlertAction(title: "发送图片", style: .Default) { (Action) in
            self.demoData.addPhotoMediaMessage()
            self.finishSendingMessageAnimated(true)
        }
        
        let vedioAction = UIAlertAction(title: "发送视频", style: .Default) { (Action) in
            self.demoData.addVideoMediaMessage()
            self.finishSendingMessageAnimated(true)

        }
        
        let audioAction = UIAlertAction(title: "发送音频", style: .Default) { (Action) in
            self.demoData.addAudioMediaMessage()
            self.finishSendingMessageAnimated(true)

        }
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(photoAction)
        actionSheet.addAction(vedioAction)
        actionSheet.addAction(audioAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    
    //MARK: -  JSQMessagesComposerTextViewPasteDelegate 
    
    func composerTextView(textView: JSQMessagesComposerTextView!, shouldPasteWithSender sender: AnyObject!) -> Bool {
        
        return true
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
    //MARK: - UICollectionView DataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    
    //MARK: - JSQMessages collection view flow layout delegate
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if (indexPath.item % 3 == 0) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault;
        }
        
        return 0.0;
    }
    
    /**
     返回每个消息气泡的高度
     
     - parameter collectionView:       <#collectionView description#>
     - parameter collectionViewLayout: <#collectionViewLayout description#>
     - parameter indexPath:            <#indexPath description#>
     
     - returns: <#return value description#>
     */
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        let currentMessage = self.demoData.messages[indexPath.item] as! JSQMessage
        if currentMessage.senderId == self.getSenderId(){
          return 0
        }
        
        if(indexPath.item - 1>0){
          let previousMessage = self.demoData.messages[indexPath.item-1] as! JSQMessage
            if(previousMessage.senderId == currentMessage.senderId){
             return 0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
        
    }
   override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 0
    }
    
    //MARK: - Responding to collection view tap events
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        print("获取更早的聊天消息")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        print("您点击了头像")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        print("您点击了聊天气泡")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        print("Tapped cell at:\(NSStringFromCGPoint(touchLocation))")

    }
    
   
  

}




