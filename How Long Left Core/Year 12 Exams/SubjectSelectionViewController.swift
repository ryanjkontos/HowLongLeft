//
//  SubjectSelectionViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class SubjectSelectionViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, SubjectSelectionRowDelegate {
    
    var allSubjects = Subject.alphabeticallySorted()
    var selectedSubjects = [Subject]()
    
    @IBOutlet weak var selectionString: NSTextField!
    
    @IBOutlet weak var table: NSTableView!

    override func viewWillAppear() {
        
        self.loadSubjects()
        table.delegate = self
        table.dataSource = self
        self.table.reloadData()
        
    }
    

    func loadSubjects() {
        
        selectedSubjects = HLLDefaults.magdalene.hscSubjects
        updateSelectionString()
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return allSubjects.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SubjectCell"), owner: nil) as? SubjectSelectionRow {
            
            var isSelected = false
            
            if selectedSubjects.contains(allSubjects[row]) {
                isSelected = true
            }
            
            
            cell.setup(delegate: self, subject: allSubjects[row], enabled: isSelected)
            
            return cell
            
        }
        
        return nil
        
    }
    

    func valueChanged(for subject: Subject, to value: Bool) {
        
        if value == true {
            
            selectedSubjects.append(subject)
            
        } else {
            
            if let index = selectedSubjects.firstIndex(of: subject) {
                
                selectedSubjects.remove(at: index)
                
            }
            
        }

        HLLDefaults.magdalene.hscSubjects = selectedSubjects
        updateSelectionString()
        
        
        print("Selected subjects: \(HLLDefaults.magdalene.hscSubjects.count)")

    }
    
    func updateSelectionString() {
        
        self.selectionString.stringValue = generateSelectionSummaryString()
        
    }
    
    func generateSelectionSummaryString() -> String {
        
        let show = 7
        
        let selectedTitles = self.selectedSubjects.map({$0.subjectName}).sorted { $0.lowercased() < $1.lowercased() }
        
        if selectedTitles.isEmpty {
            return "You haven't selected any subjects."
        }
        
        var returnText = "You have selected "
        
        
        let displayTitles = selectedTitles.prefix(show)
        
        for (index, title) in displayTitles.enumerated() {
            
            returnText += "\(title)"
            
            if index == displayTitles.indices.last!-1, selectedTitles.count <= show {
               returnText += ", and "
            }
            
            else if index != displayTitles.indices.last! {
                returnText += ", "
            }
            
        }
        
        if selectedTitles.count > show {
            
            let moreCount = selectedTitles.count - show
            returnText += ", and \(moreCount) more."
            
        } else {
            returnText += "."
        }
        
        return returnText
        
    }
    
}
