//
//  UpcomingCellView.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 27/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class UpcomingCellView: RepesentedEventView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let backgroundView = UIView()
    
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    
    let sidebar = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func configureForEvent(event: HLLEvent) {
        
        super.configureForEvent(event: event)
        
        titleLabel.text = event.title
        infoLabel.text = "\(event.startDate.formattedTime()) - \(event.endDate.formattedTime())"
        self.backgroundView.backgroundColor = event.color.withAlphaComponent(0.25)
        sidebar.backgroundColor = event.color.withAlphaComponent(0.5)
    }
    
    override func configure() {
        
        super.configure()
        
        self.backgroundColor = UIColor.systemBackground
        
        backgroundView.frame = self.bounds
        
        addSubview(backgroundView)
        
        
        
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = 12.0
        layer.masksToBounds = true
        
        sidebar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = .label.withAlphaComponent(0.9)
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        infoLabel.textColor = .secondaryLabel.withAlphaComponent(0.5)
        infoLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        addSubview(sidebar)
        addSubview(titleLabel)
        addSubview(infoLabel)
        
        
        NSLayoutConstraint.activate([
            
            sidebar.leadingAnchor.constraint(equalTo: leadingAnchor),
            sidebar.widthAnchor.constraint(equalToConstant: 9),
            sidebar.heightAnchor.constraint(equalTo: heightAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: sidebar.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            infoLabel.leadingAnchor.constraint(equalTo: sidebar.trailingAnchor, constant: 10),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
            
        ])
        
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        
    }
    
    override func layoutSubviews() {
        backgroundView.frame = self.bounds
        super.layoutSubviews()
    }
    
}
