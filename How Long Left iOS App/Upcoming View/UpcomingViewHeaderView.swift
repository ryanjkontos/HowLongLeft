//
//  UpcomingViewHeaderView.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 27/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class UpcomingViewHeaderView: UICollectionReusableView {
        
    
    
    let stack = UIStackView()
    
    let dayLabel = UILabel()
    let dateLabel = UILabel()
    
    let relativeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func update(for date: Date) {
        
        dayLabel.text = date.shortDayName()
        dateLabel.text = date.dayNumber()
        
        relativeLabel.text = getRelativeString(numberOfDays: date.daysUntil())
        
    }
    
    func getRelativeString(numberOfDays: Int) -> String {
        
        if numberOfDays == 0 {
            return "Today"
        }
        
        if numberOfDays == 1 {
            return "Tomorrow"
        }
        
        return "\(numberOfDays) days away"
        
    }
    
    func configure() {
        
        self.backgroundColor = .systemBackground
        
     //   stack.backgroundColor = .systemGreen
      //  backgroundColor = .systemPink
        
        relativeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        relativeLabel.textColor = .secondaryLabel
        
        
        dayLabel.font = .systemFont(ofSize: 14, weight: .medium)
        dayLabel.textColor = .systemRed
        
        dateLabel.font = .systemFont(ofSize: 30, weight: .light)
        
        dateLabel.text = "31"
        
        
        dateLabel.textColor = .label
        
        stack.axis = .vertical
        
       
        stack.alignment = .center
        
        stack.addArrangedSubview(dayLabel)
        stack.addArrangedSubview(dateLabel)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(relativeLabel)
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.heightAnchor.constraint(equalToConstant: 52),
            stack.widthAnchor.constraint(equalToConstant: 50),
        
            relativeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            relativeLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            
            
        ])
        
    }
    
    
}

extension Date {
    
    func shortDayName() -> String {
        
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: date).uppercased()
        
    }
    
    func dayNumber() -> String {
        
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
        
    }
    
   
}
