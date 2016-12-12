//
//  ContactTableViewController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/30/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit
import SwiftyJSON
import SocketIO

class ContactTableViewController: UITableViewController {

    var contactsArray = [Contact]()
    var filteredContacts = [Contact]()
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    var room: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add search bar to the top of table view
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        definesPresentationContext = true
        tableView.tableHeaderView = resultSearchController.searchBar
        
        //data that will be pass together with url and path in GET request
        var getParams: String
        getParams = "?token=\(Config.token)"
        
        //send REST request for contacts then put results in contactsArray
        RestApiManager.sharedInstance.httpGetRequest(getParams, path: "contacts", onCompletion: {(response) in
            for (_, value):(String, JSON) in response{

                let contact = value.dictionary
                self.contactsArray += [Contact(name: (contact?["name"]?.stringValue)!,photo: (contact?["imageLarge"]?.stringValue)!,statusMessage: (contact?["status_message"]?.stringValue)!, email: (contact?["email"]?.stringValue)!, employeeId:(contact?["employee_id"]?.stringValue)!, status: (contact?["status"]?.int)!, id: (contact?["id"]?.int)!)]
                
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        SocketIOManager.sharedInstance.socket.on("contact-online"){ data, ack in
            
            //I got the ID of the user who got connected, what I need to do
            //now is to use that ID to identify the index of contact in contactsArray[ContactItem]
            let contact: Dictionary<String, Any> = data[0] as! Dictionary<String, Any>
            let id: Int = contact["contactId"] as! Int
            
            let indexInContactsArray = self.contactsArray.index(where:{$0.id == id})

            self.contactsArray[indexInContactsArray!].status = 1

            self.tableView.reloadData()
            
        }
        
        SocketIOManager.sharedInstance.socket.on("contact-offline"){ data, ack in
            //I got the ID of the user who got connected, what I need to do
            //now is to use that ID to identify the contact in contactsArray
            let contact: Dictionary<String, Any> = data[0] as! Dictionary<String, Any>
            let id: Int = contact["contactId"] as! Int
            let indexInContactsArray = self.contactsArray.index(where:{$0.id == id})
            
            self.contactsArray[indexInContactsArray!].status = 0
            self.tableView.reloadData()
        }
        
        //tableView.reloadData()
        
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
        if resultSearchController.isActive && resultSearchController.searchBar.text != ""{
            return filteredContacts.count
        }
        
        return self.contactsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactTableViewCell
        let contact: Contact
        var ledImage: UIImage
        
        if self.resultSearchController.isActive && resultSearchController.searchBar.text != ""{
            //cell?.textLabel?.text = filteredContacts[indexPath.row]
            contact = filteredContacts[indexPath.row]
        }else{
            contact = contactsArray[indexPath.row]
        }
    
        //determine if led to display is on or off
        ledImage = contact.status == 1 ? #imageLiteral(resourceName: "ledon"): #imageLiteral(resourceName: "ledoff")
        
        cell.nameLabel.text = contact.name
        cell.statusLabel.text = contact.statusMessage
        cell.profileImage.imageFromUrl(contact.photo)
        cell.ledImage.image = ledImage
        
        return cell

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showDetail"{
            
            if let indexPath = tableView.indexPathForSelectedRow{
                let contact = contactsArray[indexPath.row]
                let controller = (segue.destination as! UITableViewController) as! ContactDetailViewController
                controller.detailContact = contact
            }
        }
        
        if segue.identifier == "callContact"{
            let callView: CallViewController = segue.destination as! CallViewController
            let data: String = sender as! String
            callView.roomName = data
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filteredContacts = contactsArray.filter{contact in
            return contact.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    @IBAction func callContact(_ sender: UIButton) {
        
        if let roomNameValue: String = room{
            if !roomNameValue.isEmpty{
                self.performSegue(withIdentifier: "callContact", sender: roomNameValue)
            }else{
                print("Room name cannot be left blank")
            }
        }else{
            print("Enter the room name")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)! as! ContactTableViewCell
        room = selectedCell.nameLabel.text
        print(room)
    }


}

extension ContactTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController){
        filterContentForSearchText(searchText: resultSearchController.searchBar.text!)
    }
}
