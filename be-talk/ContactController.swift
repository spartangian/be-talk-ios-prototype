//
//  ContactController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/23/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    let json = JSON("{\"contacts\":\"gian\"}")
    
    var contactsArray = [ContactItem]()
    var filteredContacts = [ContactItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.contactsArray += [ContactItem(name: "Taku", photo:"test", status: "test")]
        //self.contactsArray += [ContactItem(name: "Masa", photo:"test", status: "test")]
        
        self.tableView.reloadData()
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        var data: String
        var token: String
        
        token = Request.token!
        
        data = "?token=\(token)"
        
        //send REST request for contacts
        RestApiManager.sharedInstance.httpGetRequest(data, path: "contacts", onCompletion: {(response) in
            for (_, value):(String, JSON) in response{

                let test = value.dictionary
                //self.contactsArray += [ContactItem(name: (test?["name"]?.stringValue)!,photo: (test?["image"]?.stringValue)!,status: (test?["status_message"]?.stringValue)!)]
                
                self.tableView.reloadData()
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactsArray.count
//        if(tableView == self.result.searchResultsTableView){
//            return self.filteredContacts.count
//        }else{
//            return self.contactsArray.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
//        
//        cell.textLabel?.text = self.contactsArray[indexPath.row].name
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\((indexPath as NSIndexPath).row)!")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?
//        
//        var contact: ContactItem
//        
//        if(tableView == self.searchDisplayController?.searchResultsTableView){
//            contact = self.filteredContacts[indexPath.row]
//        }else{
//            contact = self.contactsArray[indexPath.row]
//        }
//        
//        cell?.textLabel?.text = contact.name
//        
//        return (cell != nil)
//    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: <#T##IndexPath#>, animated: true)
//        
//        var contact: ContactItem
//        
//        if(tableView == self.presentSearchController(<#T##searchController: UISearchController##UISearchController#>))
//    }
//    
}
