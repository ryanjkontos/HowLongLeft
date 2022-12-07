//
//  SelectedTabManager.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation
import Combine

class SelectedTabManager: ObservableObject {
    
    static var shared = SelectedTabManager()
    
    let reselected = PassthroughSubject<Void, Never>()
    
    @Published var selectedTab: HLLAppTab = .inProgress
    
    var selectedIndex = 0 {
        
        didSet {
            
            if oldValue != selectedIndex {
                selectedTab = HLLAppTab(rawValue: selectedIndex)!
            } else {
                // print("Reselect")
                reselected.send()
            }
            
        }
        
    }
    
   

    
}
