//
//  ContactDetailViewController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 10/3/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit

class ContactDetailViewController: UITableViewController {

    @IBOutlet weak var textName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var textEmail: UILabel!
    @IBOutlet weak var textStatusMessage: UILabel!
    @IBOutlet weak var textEmployeeId: UILabel!
    
    var detailContact: Contact?{
        didSet{
            configureView()
        }
    }
    
    func configureView(){
        if let detailContact = detailContact{
            if let textName = textName, let imageProfile = imageProfile{
                textName.text = detailContact.name
                imageProfile.imageFromUrl(detailContact.photo)
                textStatusMessage.text = detailContact.statusMessage
                textEmail.text = detailContact.email
                textEmployeeId.text = detailContact.employeeId
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
