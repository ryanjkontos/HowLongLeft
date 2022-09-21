//
//  SwitchCell.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 19/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit

class TitleDetailCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var cellIdentifier = ""
    
    var selectionHandler: ( () -> Void )? {
        
        didSet {
            
            setSelectionStyle()
            
        }
        
    }
    
    var title: String? {
        
        get {
           
            return titleLabel.text
            
        }
        
        set (to) {
            
           titleLabel.text = to
            
        }
        
    }
    
    var detail: String? {
        
        get {
           
            return detailLabel.text
            
        }
        
        set (to) {
            
           detailLabel.text = to
            
        }
        
    }
    
    override func awakeFromNib() {
        titleLabel.text = nil
        detailLabel.text = nil
        setSelectionStyle()
    }
    
    func setSelectionStyle() {
        
        if selectionHandler != nil {
            accessoryType = .disclosureIndicator
            selectionStyle = .default
        }
        
        
    }
    
}
