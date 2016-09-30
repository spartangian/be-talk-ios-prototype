//
//  ContactTableViewController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/30/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactTableViewController: UITableViewController, UISearchResultsUpdating {

    var contactsArray = [ContactItem]()
    var contactsNameArray = [String]()
    var filteredAppleProducts = [String]()
    var resultSearchController = UISearchController()
    
    @IBOutlet weak var textStatus: UILabel!
    @IBOutlet weak var textName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add search bar to the top of table view
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        var data: String
        var token: String
        
        token = Request.token!
        
        data = "?token=\(token)"
        
        //send REST request for contacts
        RestApiManager.sharedInstance.httpGetRequest(data, path: "contacts", onCompletion: {(response) in
            for (_, value):(String, JSON) in response{
                
                let test = value.dictionary
                self.contactsArray += [ContactItem(name: (test?["name"]?.stringValue)!,photo: (test?["image"]?.stringValue)!,status: (test?["status_message"]?.stringValue)!)]
                
                self.contactsNameArray.append((test?["name"]?.stringValue)!)
                
                self.tableView.reloadData()
            }
        })
        self.tableView.reloadData()
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
        if self.resultSearchController.isActive{
            return self.filteredAppleProducts.count
        }else{
            return self.contactsArray.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell?
        
        if self.resultSearchController.isActive{
            cell?.textLabel?.text = self.filteredAppleProducts[indexPath.row]
        }else{
            cell?.textLabel?.text = self.contactsArray[indexPath.row].name
            cell?.imageView?.imageFromUrl(self.contactsArray[indexPath.row].photo)
            cell?.detailTextLabel?.text = self.contactsArray[indexPath.row].status
        }
        
        return cell!

    }
 
    //called when search bar is used
    func updateSearchResults(for searchController: UISearchController) {
        
//        //remove all items in filtered
//        self.filteredAppleProducts.removeAll(keepingCapacity: false)
//        
//        //take whatever in search bar
//        //we use this to find the text
//        let searchPredicate = NSPredicate(format: "contactsNameArray CONTAINS[c] %@", searchController.searchBar.text!)
//        
//        //find the text in appleproducts
//        let array = (self.contactsArray as NSArray).filtered(using: searchPredicate)
//        
//        self.filteredAppleProducts = array as! [String]
//        
        self.tableView.reloadData()
    }

}
