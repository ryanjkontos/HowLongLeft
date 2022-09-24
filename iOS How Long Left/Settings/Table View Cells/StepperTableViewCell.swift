//
//  StepperTableViewCell.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 24/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class StepperTableViewCell: UITableViewCell {

    let stepper = UIStepper(frame: .zero)
   
    let stack = UIStackView()
    
    let indicator = UIView()
    
    let label = UILabel()
    
    var updateAction: ((Int) -> ())?
    
    var labelUpdator: (() -> (String))? {
        didSet {
            updateState()
        }
    }
    
  
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryView = stepper
        
        stepper.addTarget(self, action: #selector(stepperChanged), for: UIControl.Event.valueChanged)
       
        indicator.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.backgroundColor = .systemPink
        
        
        contentView.addSubview(label)
   
        
        contentView.addSubview(label)
        indicator.layer.cornerRadius = 12 / 2
        indicator.clipsToBounds = true
      
        configureContraints()

        
    }
    

    
    func updateState(_ animated: Bool = false) {
        
        if let text = labelUpdator?() {
            self.label.text = text
        }
        
        
    }
    
    @objc func stepperChanged(stepper: UIStepper) {
        
        updateAction?(Int(stepper.value))
        updateState()
        
    }
    
    func configureContraints() {
        
        indicator.removeFromSuperview()
        label.removeFromSuperview()
        
        contentView.addSubview(label)
    
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
