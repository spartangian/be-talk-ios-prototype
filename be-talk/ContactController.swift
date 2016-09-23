//
//  ContactController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/23/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit

class ContactController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var items: [String] = ["test"]

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        //cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
