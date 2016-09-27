//
//  ProfileController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/9/16.
//  Copyright © 2016 Gian Paolo Balaag. All rights reserved.
//

import UIKit
import SwiftyJSON


class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleProfile: UINavigationItem!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var items: [String] = [UserModel.Static.username, UserModel.Static.email]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        
        self.titleProfile.title = UserModel.Static.name
        imageProfile.imageFromUrl(UserModel.Static.imageLarge)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logout(sender: UIButton) {
        
        var token: String = ""
        
        token = Request.token!
        
        RestApiManager.sharedInstance.httpGetRequest("?token=\(token)",path: "logout", onCompletion: {(json: JSON) in
            print(json)
        })
        
        performSegueWithIdentifier("logoutSegue", sender: nil)
        
    }

}

