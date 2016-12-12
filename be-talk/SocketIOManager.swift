//
//  SocketIOManager.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 10/14/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    
    var jwtConfig: Dictionary<String, Any> = ["secure":true, "query": "jwt=\(Config.token)"]
    var secure: Bool = true
    var token: String
    let socket: SocketIOClient

    
    //var configs: SocketIOClientConfiguration.Element = SocketIOClientOption.connectParams(["query" : "jwt=\(Request.token)"])
    
    //var opt = SocketIOClientOption.connectParams(["query": "jwt=\(Request.token)"])
    
    //var ccc = SocketIOClientConfiguration(arrayLiteral: SocketIOClientOption.connectParams(["query": "jwt=\(Request.token)"]))
    
    override init() {
        self.token = Config.token
        self.socket = SocketIOClient(socketURL: URL(string: Config.socketURL)!, config: SocketIOClientConfiguration(arrayLiteral: SocketIOClientOption.connectParams(["jwt": self.token])))
        super.init()
    }
    
    func establishConnection(){
        self.socket.connect()
    }
    
    func closeConnection(){
        self.socket.disconnect()
    }

}
