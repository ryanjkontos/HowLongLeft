//
//  ControllableTabView.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 21/6/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class ControllableTabView: NSTabViewController {
    
    func goToIndex(_ tabIndex: Int) {
        
        DispatchQueue.main.async {
        
            [unowned self] in
            
        if tabIndex < self.tabView.tabViewItems.count, tabIndex > -1 {
            
            self.tabView.selectTabViewItem(at: tabIndex)
            
        }
            
        }
    }
    

    func previousPage() {
        
        DispatchQueue.main.async {
        
            [unowned self] in
            
            let index = self.indexOfSelectedItem()-1
        
        if index < self.tabView.tabViewItems.count, index > -1 {
            
            self.tabView.selectTabViewItem(at: index)
            
        }
            
        }
    }
    
    
    func nextPage() {
        
        DispatchQueue.main.async {
            
            [unowned self] in
            
            let index = self.indexOfSelectedItem()+1
        
        if index < self.tabView.tabViewItems.count, index > -1 {
            
            self.tabView.selectTabViewItem(at: index)
            
        }
        
        }
    }
    
    func indexOfSelectedItem() -> Int {
        
        let current = tabView.selectedTabViewItem!
        let index = tabView.indexOfTabViewItem(current)
        return index
        
        
    }
    
     private lazy var tabViewSizes: [String : NSSize] = [:]
    
    
 override func viewDidLoad() {
        super.viewDidLoad()
    
   NSApp.activate(ignoringOtherApps: true)
  
    
}

}
