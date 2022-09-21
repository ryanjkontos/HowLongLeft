//
//  StackedInfoItemCell.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 31/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class StackedInfoItemCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    func setup(type: String, info: String) {
        
        typeLabel.text = type
        infoLabel.text = info
        
    }

}
