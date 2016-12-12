//
//  MessageTableViewCell.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 10/19/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageSummaryLabel: UILabel!
    var conversationId: Int = 0
    var receiverId: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contactImage.layer.masksToBounds = true
        contactImage.layer.cornerRadius = 25.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getConversationId() -> String {
        return self.nameLabel.text!
    }
    
}
