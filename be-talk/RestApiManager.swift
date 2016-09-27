//
//  RestApiManager.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/15/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    
    static let sharedInstance = RestApiManager()
    
    let baseURL = "https://be-talk-dev.tmjp.jp/api/"
    
    func postRequest(_ path: String, data: [String: AnyObject], onCompletion: (JSON) -> Void){
        let route = baseURL
        makeHttpPostRequest(route, body: data, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func httpGetRequest(_ data: String, path: String, onCompletion: (JSON) -> Void) {
        var route: String!
        
        route = baseURL + path + data
        
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    //complicated version for sending POST request
    func makeHttpPostRequest(_ path: String, body: [String: AnyObject], onCompletion: ServiceResponse){
        
        let request = NSMutableURLRequest(url: URL(string: path)!)
        
        //set the method to post
        request.httpMethod = "POST"
        
        do{
            //set the post body for the request
            let jsonBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.httpBody = jsonBody
            let session = URLSession.shared
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                if let jsonData = data{
                    let json:JSON = JSON(data: jsonData)
                    return onCompletion(json, nil)
                }else{
                    onCompletion(nil, error)
                }
            })
            task.resume()
            
        }catch{
            onCompletion(nil, nil)
        }
    }
    
    
    //simple function for sending POST request
    func httpPostRequest(_ data: String?, path: String, httpResponse: (JSON?, String?) -> Void){

        let request = NSMutableURLRequest(url: URL(string: baseURL + path)!)
        let method: String = "POST"
        
        //var js: JSON?
        
        request.httpMethod = method
        
        if let requestData = data{
            request.httpBody = requestData.data(using: String.Encoding.utf8)
        }
        
        //request closure
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                
                return httpResponse(nil, "cannot connect to server: 500")
                
            }else{
                let js = JSON(data: data!)
                
                print(js)
                
                return httpResponse(js, nil)
                
                //if let token = js["token"].string {
                    //return httpResponse(token, nil)
                //}else{
                

                    
                //}
            }
            
            //let responseString = String(data: data!, encoding: NSUTF8StringEncoding)


        }) 
        
        task.resume()
        
    }
    
    // MARK: Perform a GET Request
    fileprivate func makeHTTPGetRequest(_ path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(url: URL(string: path)!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print(response)
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }
    

}
