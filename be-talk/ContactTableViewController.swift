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

    var contactsArray = [ContactItem]()
    var filteredContacts = [ContactItem]()
    var resultSearchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var textStatus: UILabel!
    @IBOutlet weak var textName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    
    var room: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add search bar to the top of table view
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        definesPresentationContext = true
        tableView.tableHeaderView = resultSearchController.searchBar
        
        var data: String
        var token: String
        
        token = Request.token!
        data = "?token=\(token)"
        
        //send REST request for contacts then put results in contactsArray
        RestApiManager.sharedInstance.httpGetRequest(data, path: "contacts", onCompletion: {(response) in
            for (_, value):(String, JSON) in response{
                
                let contact = value.dictionary
                self.contactsArray += [ContactItem(name: (contact?["name"]?.stringValue)!,photo: (contact?["imageLarge"]?.stringValue)!,statusMessage: (contact?["status_message"]?.stringValue)!, email: (contact?["email"]?.stringValue)!, employeeId:(contact?["employee_id"]?.stringValue)!, status: (contact?["status"]?.int)!)]
                
                //self.contactsNameArray.append((test?["name"]?.stringValue)!)
                print("contact loaded")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })

        tableView.reloadData()
        
//        let socket = SocketIOClient(socketURL: URL(string: "https://apprtc.appspot.com")!, config: [.log(true), .forcePolling(true)])
//        
//        socket.on("connect") {data, ack in
//            print("socket connected")
//            
//        }
//        
//        
//        print("socket connecting")
//        socket.connect()
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
        print("test")
        return self.contactsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cell for row is loaded")

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let contact:ContactItem
        
        if self.resultSearchController.isActive && resultSearchController.searchBar.text != ""{
            //cell?.textLabel?.text = filteredContacts[indexPath.row]
            contact = filteredContacts[indexPath.row]
        }else{
            contact = contactsArray[indexPath.row]
        }
        cell.textLabel?.text = contact.name
        cell.imageView?.imageFromUrl(contact.photo)
        cell.detailTextLabel?.text = contact.employeeId
        return cell

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showDetail"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let contact = contactsArray[indexPath.row]
                let controller = (segue.destination as! UITableViewController) as! ContactDetailViewController
//                let backButton = UIBarButtonItem()
                controller.detailContact = contact
                //controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                //controller.navigationItem.leftItemsSupplementBackButton = true
//                backButton.title = "eeee"
//                controller.navigationItem.backBarButtonItem = backButton
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
        let selectedCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        room = selectedCell.detailTextLabel!.text
        print(room)
    }

}

extension ContactTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController){
        filterContentForSearchText(searchText: resultSearchController.searchBar.text!)
    }
}
