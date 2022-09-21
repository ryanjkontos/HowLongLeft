//
//  MilestoneSettingsCell.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 7/2/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import UIKit


class MilestoneSettingsCell: UITableViewCell {
    
    var milestone: Int?
    
    @IBOutlet weak var milestoneItemLabel: UILabel!
    
    
    func setupCell(milestone: HLLMilestone) {
        
            milestoneItemLabel.text = milestone.settingsRowString
            
        }

    
}
