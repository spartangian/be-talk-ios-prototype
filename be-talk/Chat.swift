//
//  Chat.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 10/24/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit

enum BubbleType: Int{
    case me = 0
    case them
}

class Chat {
    
    //MARK: Properties
    var message: String?
    var image: UIImage?
    var date: NSDate?
    var type: BubbleType
    
    init(message: String?, image: UIImage?, date: NSDate?, type: BubbleType = .me){
        //default
        self.message = message
        self.image = image
        self.date = date
        self.type = type
    }
}
