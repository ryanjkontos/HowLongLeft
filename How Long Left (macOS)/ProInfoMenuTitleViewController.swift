//
//  CurrentEventMenuViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 8/5/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class ProInfoMenuTitleViewController: NSViewController {

    override var nibName: NSNib.Name? {
        
        return "ProInfoMenuTitleView"
        
    }
    
    override var nibBundle: Bundle? {
        
        return .main
        
    }
    
   

    
    override func viewDidLoad() {
        
        
    }
    
}


protocol NibLoadable {
    // Name of the nib file
    static var nibName: String { get }
    static func createFromNib(in bundle: Bundle) -> Self
}

extension NibLoadable where Self: NSView {

    // Default nib name must be same as class name
    static var nibName: String {
        return String(describing: Self.self)
    }

    static func createFromNib(in bundle: Bundle = Bundle.main) -> Self {
        var topLevelArray: NSArray? = nil
        bundle.loadNibNamed(NSNib.Name(nibName), owner: self, topLevelObjects: &topLevelArray)
        let views = Array<Any>(topLevelArray!).filter { $0 is Self }
        return views.last as! Self
    }
}

class ProInfoMenuTitleView: NSView, NibLoadable {

  
    
}
