//
//  Request.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/20/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import Foundation
import SwiftyJSON

class Request{
    static var token: String?
    static var apiToken: String?
    static var error: String?
    static var json: JSON!
    
    static let sharedInstance = Request()
}