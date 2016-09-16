//
//  LoginController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/14/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit

class LoginController : UIViewController {
    
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(sender: UIButton) {
        print(textUsername.text)
        print(textPassword.text)
        
        var data = {"username:"/(textUsername.text), "password:"/(textPassword.text)}
        
        RestApiManager.sharedInstance.postRequest([String : ], onCompletion: <#T##(JSON) -> Void#>)
    }
    
    
}
