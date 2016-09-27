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

        
        self.titleProfile.title = UserModel.Static.name
        imageProfile.imageFromUrl(UserModel.Static.imageLarge)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logout(_ sender: UIButton) {
        
        var token: String = ""
        
        token = Request.token!
        
        RestApiManager.sharedInstance.httpGetRequest("?token=\(token)",path: "logout", onCompletion: {(json: JSON) in
            print(json)
        })
        
        performSegue(withIdentifier: "logoutSegue", sender: nil)
        
    }

}

