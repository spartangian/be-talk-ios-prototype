//
//  RestApiManager.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/15/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import SwiftyJSON

//var JSON: String = ""

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    
    static let sharedInstance = RestApiManager()
    
    let baseURL = "https://be-talk-dev.tmjp.jp/api/"
    
    func postRequest(data: [String: AnyObject], onCompletion: (JSON) -> Void){
        let route = baseURL
        makeHttpPostRequest(route, body: data, onCompletion: <#T##ServiceResponse##ServiceResponse##(JSON, NSError?) -> Void#>)
    }
    
    private func makeHttpPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse){
        
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        //set the method to post
        request.HTTPMethod = "POST"
        
        do{
            //set the post body for the request
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            request.HTTPBody = jsonBody
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                if let jsonData = data{
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil)
                }else{
                    onCompletion(nil, error)
                }
            })
            task.resume()
            
        }catch{
            onCompletion(nil, nil)
        }
    }
    

}
