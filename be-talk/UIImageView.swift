//
//  UIImageView.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 9/23/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit

extension UIImageView{
    public func imageFromUrl(_ urlString: String){
        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: { response, data, error -> Void in
                if let imageData = data as Data?{
                    self.image = UIImage(data: imageData)
                }
            })//closure
        }
    }
}
