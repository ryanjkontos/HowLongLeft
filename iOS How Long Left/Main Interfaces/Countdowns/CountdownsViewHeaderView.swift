//
//  CountdownsViewHeaderView.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 27/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class CountdownsViewHeaderView: UICollectionReusableView {
        
    let text = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    

    
    func configure() {
        
        text.translatesAutoresizingMaskIntoConstraints = false
        
        text.textColor = .secondaryLabel
        
        text.font = .systemFont(ofSize: 17, weight: .medium)
        
        addSubview(text)
        
        NSLayoutConstraint.activate([
            
            text.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            text.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            
            
        ])
        
    }
    
    
}
