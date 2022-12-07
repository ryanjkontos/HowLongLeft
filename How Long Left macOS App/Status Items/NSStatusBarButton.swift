//
//  NSStatusBarButton.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 25/8/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

extension NSStatusBarButton {
    

    func setupPasteboard() {

        
        self.registerForDraggedTypes([.fileContents, .filePromise])

        
    }
    
    open override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        
        if ProStatusManager.shared.isPro == false {
            return NSDragOperation()
        }
        
        let pasteboard = sender.draggingPasteboard
             
               if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
                   for url in urls {
                       
                       if url.absoluteString.contains(text: "ical://occurrence/"), url.pathComponents.indices.contains(1) {
                           
                        self.isHighlighted = true
                        return NSDragOperation.copy
                        
                       }
                       
                   }
               }
        
        
        self.isHighlighted = false
        return NSDragOperation()
    }
    
    open override func draggingExited(_ sender: NSDraggingInfo?) {
        self.isHighlighted = false
    }
    
    open override func draggingEnded(_ sender: NSDraggingInfo) {
        self.isHighlighted = false
    }
    
    open override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
      
        if ProStatusManager.shared.isPro == false {
            return false
        }
        
        let pasteboard = sender.draggingPasteboard
      
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            for url in urls {
                
                if url.absoluteString.contains(text: "ical://occurrence/"), url.pathComponents.indices.contains(1) {
                    
                    return true
                    
                }
                
            }
        }
        
        return false
    }
    
    open override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        DispatchQueue.global(qos: .userInteractive).async {
        
        let pasteboard = sender.draggingPasteboard
        
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            
            
            
            var ids = [String]()
            
            for url in urls {
                
                // print("Drag URL: \(url)")
                
                // print("URL Last: \(url.pathComponents.last!)")
                
                if url.absoluteString.contains(text: "ical://occurrence/"), let id = url.pathComponents.last {

                    ids.append(id)
                    
                }
                
            }
            
            
            
            EventPinningManager.shared.pinEvents(with: ids)
                
            
            
        }
            
        }
        
        return true
    }
    
}
