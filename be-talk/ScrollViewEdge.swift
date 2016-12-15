//
//  ScrollViewEdge.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 11/16/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit

enum UIScrollViewEdge { case Top, Bottom }

//extension UIScrollView {
//    
//    func scrollToEdge(position: UIScrollViewEdge, animated: Bool) {
//        let offset = verticalContentOffsetForEdge(edge: position)
//        let offsetPoint = CGPoint(x: contentOffset.x, y: offset)
//        setContentOffset(offsetPoint, animated: animated)
//        print("edge")
//    }
//    
//    func isScrolledToEdge(edge: UIScrollViewEdge) -> Bool {
//        let offset = contentOffset.y
//        let offsetForEdge = verticalContentOffsetForEdge(edge: edge)
//        print("edge")
//        switch edge {
//        case .Top: return offset <= offsetForEdge
//        case .Bottom: return offset >= offsetForEdge
//        }
//    }
//    
//    private func verticalContentOffsetForEdge(edge: UIScrollViewEdge) -> CGFloat {
//        switch edge {
//        case .Top: return 0 - contentInset.top
//        case .Bottom: return contentSize.height + contentInset.bottom - bounds.height
//        }
//    }
//    
//}
