//
//  UniversalMenuItem.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 23/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit

struct UniversalMenuItemGroup: Identifiable {
    var id = UUID()
    var items = [UniversalMenuItem]()
}

struct UniversalMenuItem: Identifiable {
    var id = UUID()
    
   
    
    var title: String
    var secondaryTitle: String?
    var image: UIImage?
    var action: ( () -> Void )?
    
    var combinedTitle: String {
        
        get {
            
            if let secondary = secondaryTitle {
                
                return "\(title) – \(secondary)"
                
            } else {
                
                return title
                
            }
            
        }
        
    }
    
    init(title: String) {
        self.title = title
    }
    
    
}
