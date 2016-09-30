//
//  LoginController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/14/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginController : UIViewController {
    
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textStatus: UILabel!
    @IBOutlet weak var buttonLogin: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        var user: String = ""
        var pass: String = ""
        
        user = textUsername.text!
        pass = textPassword.text!
        
        print(user)
        print(pass)
        
        let postString = "username=\(user)&password=\(pass)&apiToken=12345"
        let path = "login"
        
        self.buttonLogin.isEnabled = false
        self.buttonLogin.isUserInteractionEnabled = false
        self.textStatus.textColor = UIColor.black
        self.textStatus.text = "Logging in..."
        
        RestApiManager.sharedInstance.httpPostRequest(postString, path: path, httpResponse: {(js, err) in
          
            //after successful retrieving of token, asign token value to shared class property
            if let strToken = js!["token"].string{
                Request.token = strToken
                
                UserModel.Static.name = js!["user"]["name"].stringValue
                UserModel.Static.imageLarge = js!["user"]["imageLarge"].stringValue
                UserModel.Static.statusMessage = js!["user"]["status_message"].stringValue
                UserModel.Static.username = js!["user"]["employee_id"].stringValue
                UserModel.Static.id = js!["user"]["id"].int!
                UserModel.Static.email = js!["user"]["email"].stringValue
                
                //call the main view if successfully logged in
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }else{
                //output errors in label
                OperationQueue.main.addOperation {
                    self.textStatus.textColor = UIColor.init(hue: 357.0, saturation: 77.0, brightness: 100.0, alpha: 1.0)
                    self.textStatus.text = err
                }
            }
            
        })
        
        self.buttonLogin.isEnabled = true
        self.buttonLogin.isUserInteractionEnabled = true

    }
    
    
}
