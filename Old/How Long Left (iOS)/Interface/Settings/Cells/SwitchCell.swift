//
//  SwitchCell.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 19/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!
    
    var cellIdentifier = ""
    var delegate: SwitchCellDelegate?
    
    var triggersDefaultsTransferOnToggle = true
    var updateseventsOnToggle = true
    
    override func awakeFromNib() {
        #if targetEnvironment(macCatalyst)
        valueSwitch.onTintColor = .systemGreen
        #endif
    }
    
    var label: String? {
        
        get {
           
            return cellLabel.text
            
        }
        
        set (to) {
            
           cellLabel.text = to
            
        }
        
    }
    
    var setAction: ((Bool) -> Void)?
    var getAction: (() -> Bool)? {
        
        didSet {
            
            if let result = self.getAction?() {
                valueSwitch.setOn(result, animated: false)
            }
            
        }
        
    }
    
    var currentState: Bool {
        
        get {
            
            return valueSwitch.isOn
            
        }
        
    }
    
    @IBAction private func switchToggled(_ sender: UISwitch) {
        
        CATransaction.setCompletionBlock {
            
            self.setAction?(sender.isOn)
            self.delegate?.switchCellWasToggled(self)
            
            if self.triggersDefaultsTransferOnToggle {
                DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 0.5) {
                    //HLLDefaultsTransfer.shared.userModifiedPrferences()
                }
            }
            
            if self.updateseventsOnToggle {
                DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 0.5) {
                    HLLEventSource.shared.updateEvents()
                }
            }
            
        }
        
    }
    
    func update() {
        
        DispatchQueue.main.async {
        
        if let result = self.getAction?() {
            self.valueSwitch.setOn(result, animated: true)
        }
            
        }
        
    }
    
}

protocol SwitchCellDelegate {
    
    func switchCellWasToggled(_ sender: SwitchCell)
    
}
