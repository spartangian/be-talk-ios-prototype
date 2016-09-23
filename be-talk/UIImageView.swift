//
//  UIImageView.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/23/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit

extension UIImageView{
    public func imageFromUrl(urlString: String){
        if let url = NSURL(string: urlString){
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){
                (response: NSURLResponse?, data:NSData?, error:NSError?) -> Void in
                
                if let imageData = data as NSData?{
                    self.image = UIImage(data: imageData)
                }
            }//closure
        }
    }
}