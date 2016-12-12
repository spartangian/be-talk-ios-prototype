//
//  MessageTableViewController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 10/19/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageTableViewController: UITableViewController {
    
    //MARK: Properties
    var messagesArray = [Message]()
    var token: String = ""
    var contacts: JSON!
    var conversation: JSON!

    @IBOutlet weak var imageProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call REST endpoint /contacts using GET HTTP verb
        //with token included in the query
        RestApiManager.sharedInstance.httpGetRequest("?token=\(Config.token)", path: "contacts", onCompletion: { response in
            for (_, value):(String, JSON) in response{
                self.contacts = value
                
                self.conversation = self.contacts["conversation"]
                let a = Message(content: (self.conversation["last_message"]["message"].stringValue),
                                name: (self.contacts["name"].stringValue),
                                conversationId: (self.conversation["id"].intValue),
                                isGroup: false,
                                receiverId: self.contacts["id"].intValue,
                                file: false,
                                type: "",
                                image: self.contacts["imageSmall"].stringValue)
                
                self.messagesArray.append(a)
                
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.messagesArray.count
    }

    /* Loads each row in the table */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        let message: Message
        
        message = self.messagesArray[indexPath.row]
        
        //configure the cell
        cell.messageSummaryLabel.text = message.content
        cell.nameLabel.text = message.name
        cell.contactImage.imageFromUrl(message.image)
        cell.conversationId = message.conversationId
        cell.receiverId = message.receiverId

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedCell = tableView.cellForRow(at: indexPath)! as! MessageTableViewCell
        //selectedCell.target(forAction: #selector(chatUser), withSender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let cell = sender as! MessageTableViewCell
        //let i = self.tableView.indexPath(for: cell)!.row
        //chatController.conversationId = conversationId
        //print(conversationId)
        let chatController: ChatViewController = segue.destination as! ChatViewController
        chatController.conversationId = cell.conversationId
        chatController.receiverName = cell.nameLabel.text!
        chatController.receiverId = cell.receiverId

    }
    
    
    //MARK: Actions
    func chatUser(sender: Any?) -> Void{
        self.performSegue(withIdentifier: "chatUser", sender: sender)
    }

}
