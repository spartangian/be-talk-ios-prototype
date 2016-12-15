//
//  LoginViewController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/14/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit
import SwiftyJSON


class LoginViewController : UIViewController {
    
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textStatus: UILabel!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var formView: UIView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.formView.layer.cornerRadius = 10
        self.buttonLogin.layer.cornerRadius = 10
        
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        var user: String = ""
        var pass: String = ""
        
        user = textUsername.text!
        pass = textPassword.text!
        
        let postString = "username=\(user)&password=\(pass)&apiToken=\(Config.apiToken)"
        let path = "login"
        
        self.buttonLogin.isEnabled = false
        self.buttonLogin.isUserInteractionEnabled = false
        self.textStatus.textColor = UIColor.black
        self.textStatus.text = "Logging in..."
                      
        RestApiManager.sharedInstance.httpPostRequest(data: postString, path: path, httpResponse: {(js, err) in

            //after successful retrieving of token, asign token value to shared class property
            if let strToken = js!["token"].string{
            //if err != nil{
            
                //we will use this toke thgoughout the application lifecycle
                Config.token = strToken//js!["token"].stringValue
                
                User.Static.name = js!["user"]["name"].stringValue
                User.Static.imageLarge = js!["user"]["imageLarge"].stringValue
                User.Static.imageMedium = js!["user"]["image"].stringValue
                User.Static.statusMessage = js!["user"]["status_message"].stringValue
                User.Static.username = js!["user"]["employee_id"].stringValue
                User.Static.id = js!["user"]["id"].int!
                User.Static.email = js!["user"]["email"].stringValue
                
                print(User.Static.imageMedium)
                
                //connect to socket
                SocketIOManager.sharedInstance.establishConnection()
                
                //redirect to main view if successfully logged in
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                
            }else{
                //output errors in label
                OperationQueue.main.addOperation {
                    self.textStatus.textColor = UIColor.init(hue: 357.0, saturation: 77.0, brightness: 100.0, alpha: 1.0)
                    self.textStatus.text = err
                }
                
                self.buttonLogin.isEnabled = true
                self.buttonLogin.isUserInteractionEnabled = true
            }
            
        })
        

    }
    
    
}
