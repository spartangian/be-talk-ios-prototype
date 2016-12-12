//
//  ChatViewController.swift
//  
//
//  Created by Gian Paolo Balaag on 11/25/16.
//
//

import UIKit
import SwiftyJSON
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    //initialize message object
    var messages = [JSQMessage]()
    var avatars = [String: JSQMessagesAvatarImage]()
    
    
    //initialize message bubble
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red:0.34, green:0.73, blue:0.95, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor(red:0.88, green:0.93, blue:0.99, alpha:1.0))
    
    var conversationId: Int = 0
    var receiverName: String = ""
    var receiverId: Int = 0
    
    let messageSavePath: String = "messages"
    let loadMessagePath: String = "messages/load"
    var senderAvatar: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        
        self.loadMessages()
        
        self.navigationItem.title = self.receiverName
        self.edgesForExtendedLayout = []
        
        SocketIOManager.sharedInstance.socket.on("message-received", callback: { data, ack in
            
            //transform socket data to dictionary
            let socketMessage: Dictionary<String, Any> = data[0] as! Dictionary<String, Any>
            
            //transform sender data to dictionary type
            let senderData: Dictionary<String, Any> = socketMessage["sender"] as! Dictionary<String, Any>
            let senderId: Int = senderData["id"]! as! Int
            let senderDisplayName: String = senderData["name"]! as! String
            let senderMessage: String = socketMessage["message"] as! String
            self.senderAvatar = senderData["image"]! as! String
            
            //create avatar for message bubble
            self.createAvatar(senderId: "\(senderId)", imageUrl: self.senderAvatar)
            
            let message = JSQMessage(senderId: "\(senderId)", displayName: senderDisplayName, text: senderMessage)
            
            self.appendMessage(data: message!)
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //reload messages on canvass
    func reloadMessages(){
        self.collectionView?.reloadData()
    }
    
    func appendMessage(data: JSQMessage){
        //let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
        self.messages.append(data)
        self.reloadMessages()
    }

    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> Void){
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func createAvatar(senderId: String, imageUrl: String){
        let url = URL(string: imageUrl)
        self.getDataFromUrl(url: (url)!, completion: { (data, URLResponse, error) in
            guard let data = data, error == nil else{
                return
            }
            
            DispatchQueue.main.async{
                let img = UIImage(data: data)
                self.avatars[senderId] = JSQMessagesAvatarImageFactory.avatarImage(with: img, diameter: 30)
                print(self.avatars)
            }
            

        })
    }
    
}

//MARK: Setup
extension ChatViewController{
    
    func setup(){
        //sender
        self.senderId = "\(User.Static.id)"
        self.senderDisplayName = User.Static.name
        //receiver
    }
}

//MARK - Data Source
extension ChatViewController {
    
    //how many messages we have
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    //which message to be displayed where
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    //what to do when a message is deleted
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didDeleteMessageAt indexPath: IndexPath!) {
        self.messages.remove(at: indexPath.row)
    }
    
    //which bubble to choose
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    //what to use as an avatar
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.row]
        return avatars[message.senderId]
    }
    
    func loadMessages() -> Void {
        
        let request = "id=\(self.conversationId)"
        
        RestApiManager.sharedInstance.httpPostRequest(data: request, path: self.loadMessagePath, httpResponse: {(js, error) in
            
            if error == nil{
                
                if js != nil{
                    
                    //loop through json data got from messages/load
                    for message in js!{
                        //create avatar for message bubble
                        self.createAvatar(senderId: message.1["sender_id"].stringValue, imageUrl: message.1["sender"]["image"].stringValue)
                        
                        self.appendMessage(data: JSQMessage(senderId: message.1["sender_id"].stringValue, displayName: message.1["sender"]["name"].stringValue, text: message.1["message"].stringValue))
                    }
                    
                }
            }else{
                //self.messages = JSON("{error: \(error)}")
                print("test")
            }
        })
    }
}

//MARK - Toolbar
extension ChatViewController {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        //message for JSQUI bubble
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        
        self.saveMessage(text: text)
        
        self.appendMessage(data: message!)
        
        self.finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        //
    }
    
    func saveMessage(text: String){
        
        //message to be sent in database through REST
        let request: String = "content=\(text)&conversationId=\(self.conversationId)&isGroup=&type=\(false)&type=1&receiverId=\(self.receiverId)"
        
        //REST
        RestApiManager.sharedInstance.httpPostRequest(data: request, path: self.messageSavePath, httpResponse: {(json, err) in
            
            if let error = json!["error"].string {
                print(error)
            }else{
                //send message through socket when saving message is successfull
                self.sendMessage(text: text)
            }
            
        })
    
    }
    
    func sendMessage(text: String){
        
        //message variable used for socket transport
        var socketMessage: Dictionary<String, Any> = [:]
        var sender: Dictionary<String, Any> = [:]
        
        sender = ["id":User.Static.id,"name":User.Static.name, "image":User.Static.imageMedium]
        
        socketMessage = ["message":["content":text, "conversationId":self.conversationId,"isGroup":false,"receiverId":self.receiverId,"file":false,"type":""],"sender":sender]
        
        //transmit message through socket
        SocketIOManager.sharedInstance.socket.emit("message-sent", with: [socketMessage])
    }
}
