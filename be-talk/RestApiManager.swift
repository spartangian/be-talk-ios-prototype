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
    
    func postRequest(path: String, data: [String: AnyObject], onCompletion: (JSON) -> Void){
        let route = baseURL
        makeHttpPostRequest(route, body: data, onCompletion: {json, err in
            onCompletion(json as JSON)
        })
    }
    
    func httpGetRequest(data: String?, path: String, onCompletion: (JSON) -> Void) {
        var route: String!
        
        route = baseURL + path + data!
        
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    //complicated version for sending POST request
    func makeHttpPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse){
        
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
    func httpPostRequest(data: String?, path: String, httpResponse: (JSON?, String?) -> Void){

        let request = NSMutableURLRequest(URL: NSURL(string: baseURL + path)!)
        let method: String = "POST"
        
        //var js: JSON?
        
        request.HTTPMethod = method
        
        if let requestData = data{
            request.HTTPBody = requestData.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        //request closure
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
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


        }
        
        task.resume()
        
    }
    
    // MARK: Perform a GET Request
    private func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
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
