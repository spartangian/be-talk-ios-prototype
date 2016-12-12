//
//  ProfileViewController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/9/16.
//  Copyright © 2016 Gian Paolo Balaag. All rights reserved.
//

import UIKit
import SwiftyJSON


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleProfile: UINavigationItem!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var items: [String] = [User.Static.username, User.Static.email]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((indexPath as NSIndexPath).row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        
        self.titleProfile.title = User.Static.name
        imageProfile.imageFromUrl(User.Static.imageLarge)
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logout(_ sender: UIButton) {
        
        var token: String = ""
        
        token = Config.token
        
        RestApiManager.sharedInstance.httpGetRequest("?token=\(token)",path: "logout", onCompletion: {(json: JSON) in
            SocketIOManager.sharedInstance.closeConnection()
        })
        
        performSegue(withIdentifier: "logoutSegue", sender: nil)
        
    }

}

