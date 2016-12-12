//
//  Message.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 10/19/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit

struct Message {
    
    var content: String!
    var name: String!
    var conversationId: Int!
    var isGroup: Bool!
    var receiverId: Int!
    var file: Bool!
    var type: Any!
    var image: String!
    
    init(content: String!, name: String!, conversationId: Int!, isGroup: Bool!, receiverId: Int!, file: Bool!, type: Any!, image: String) {
        self.content = content
        self.name = name
        self.conversationId = conversationId
        self.isGroup = isGroup
        self.receiverId = receiverId
        self.file = file
        self.type = type
        self.image = image
    }
}
