//
//  ContactController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/23/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let json = JSON("{\"contacts\":\"gian\"}")
    
    var items: [String] = ["Test", "Test2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var data: String
        var token: String
        
        token = Request.token!
        
        data = "?token=\(token)"
        
        //send REST request for contacts
        RestApiManager.sharedInstance.httpGetRequest(data, path: "contacts", onCompletion: {(JSON) in
            print(JSON)
        })
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
}
