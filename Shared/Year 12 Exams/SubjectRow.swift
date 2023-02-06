//
//  SubjectRow.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class SubjectSelectionRow: NSTableCellView {
    
    var delegate: SubjectSelectionRowDelegate?
    
    @IBOutlet weak var check: NSButton!
    var subject: Subject!
    
    func setup(delegate: SubjectSelectionRowDelegate, subject: Subject, enabled: Bool) {
        
        self.delegate = delegate
        self.subject = subject
        
        check.state = .from(bool: enabled)
        
        check.title = subject.subjectName
    }
    
    @IBAction func checkClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            self.delegate?.valueChanged(for: self.subject, to: sender.isOn)
        }

        
    }
    
    
    
}

protocol SubjectSelectionRowDelegate {
    
    func valueChanged(for subject: Subject, to value: Bool)
}
