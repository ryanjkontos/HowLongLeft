//
//  CustomNotificationsEditor.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 9/7/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import Cocoa

class CustomNotificationsEditor: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var table: NSTableView!
    
    @IBOutlet weak var segmented: NSSegmentedControl!
    
    override func viewDidLoad() {
    
        
    }
    
    @IBAction func segmentedClicked(_ sender: NSSegmentedControl) {
        
        if sender.selectedSegment == 0 {
            
            print("Segment: Add")
            
        }
        
        if sender.selectedSegment == 1 {
            
            print("Segment: Remove")
            
        }
        
    }
    
}


class CMValueCell: NSTableCellView {
    
    @IBOutlet weak var valueLabel: NSTextField!
    
    func setup(_ milestone: HLLMilestone) {
        
        
        
        
    }
    
}

class HLLMilestone: Equatable {
    
    var type: MilestoneType
    var value: Int?
    
    internal init(type: MilestoneType, value: Int) {
        self.type = type
        self.value = value
    }
    
    static func == (lhs: HLLMilestone, rhs: HLLMilestone) -> Bool {
        return lhs.type == rhs.type && lhs.value == rhs.value
    }
    
}


enum MilestoneType {
    
    case None
    case MinutesLeft
    case Percentage
    
}
