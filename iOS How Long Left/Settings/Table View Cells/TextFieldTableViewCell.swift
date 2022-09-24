//
//  TextFieldTableViewCell.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 23/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    let field = UITextField()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       
        
        field.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(field)
        
        NSLayoutConstraint.activate([
        
            field.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            field.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            field.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            field.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            
        ])
        
        field.placeholder = "Placeholder"

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
