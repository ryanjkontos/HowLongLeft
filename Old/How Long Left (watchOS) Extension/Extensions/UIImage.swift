//
//  UIImage.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 15/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


extension UIImage {
    
    func resizedTo(_ intSize:Int) -> UIImage {
        
        let size = CGSize(width: intSize, height: intSize)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: size.width, height: size.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
        
    }
    
}
