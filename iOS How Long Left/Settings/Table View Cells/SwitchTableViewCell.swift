//
//  SwitchTableViewCell.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 28/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    let toggle = UISwitch(frame: .zero)
   
    let stack = UIStackView()
    
    let indicator = UIView()
    
    let label = UILabel()
    
    var showIndicator: Bool = false {
        didSet {
            configureContraints()
        }
    }
    
 
    
    var toggleAction: ((Bool) -> ())?
    
    var stateFetcher: (() -> (Bool))? {
        didSet {
            
            updateToggleState()
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryView = toggle
        
        selectionStyle = .none
        toggle.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
       
        indicator.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.backgroundColor = .systemPink
        
       
        
        contentView.addSubview(label)
   
        
     
        
     
        contentView.addSubview(label)
        indicator.layer.cornerRadius = 12 / 2
        indicator.clipsToBounds = true
      
        configureContraints()

        
    }
    

    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        
        DispatchQueue.main.async {
            self.toggleAction?(value)
        }
        
    }
    
    func updateToggleState(_ animated: Bool = false) {
        
        // print("Toggle")
        let on = (self.stateFetcher?()) ?? false
        self.toggle.setOn(on, animated: true)
        
    }
    
    func configureContraints() {
        
        indicator.removeFromSuperview()
        label.removeFromSuperview()
        
        contentView.addSubview(label)
        
        if showIndicator {
            contentView.addSubview(indicator)
            NSLayoutConstraint.activate([
                indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                indicator.widthAnchor.constraint(equalToConstant: 11),
                indicator.heightAnchor.constraint(equalToConstant: 11),
                indicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                label.leadingAnchor.constraint(equalTo: indicator.trailingAnchor, constant: 15),
            ])
            
        } else {
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        }
        
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
