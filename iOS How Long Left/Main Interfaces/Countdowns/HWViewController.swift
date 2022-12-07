//
//  HWViewController.swift
//  How Long Left
//
//  Created by Ryan Kontos on 6/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import UIKit

class HWiOSNotificationViewController: UIViewController {
    
    let titleText: String = "5 New Shifts For Hannah"
    let bodyText: String = ""
    let shifts: [HWShift] =  [HWShift(start: Date(timeIntervalSince1970: 16070003600), end: Date(timeIntervalSince1970: 16070005400)), HWShift(start: Date(timeIntervalSince1970: 16070005400), end: Date(timeIntervalSince1970: 16070010800)), HWShift(start: Date(timeIntervalSince1970: 16070010800), end: Date(timeIntervalSince1970: 16070014400)), HWShift(start: Date(timeIntervalSince1970: 16070014400), end: Date(timeIntervalSince1970: 16070079200))]
    
    let scrollView = UIScrollView()
    let mainStackView = UIStackView()
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupScrollView()
        setupMainStackView()
        setupTitle()
        setupBody()
        setupShiftCards()
        setupTotalDuration()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupMainStackView() {
        scrollView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 15
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25)
        ])
    }
    
    func setupTitle() {
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.spacing = 5
        mainStackView.addArrangedSubview(titleStackView)
        
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.numberOfLines = 0
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.textAlignment = .left
        titleStackView.addArrangedSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        if let first = shifts.first {
            subtitleLabel.text = first.start.mondayOfWeekString()
            subtitleLabel.textColor = .secondaryLabel
            subtitleLabel.font = UIFont.systemFont(ofSize: 17)
        } else {
            subtitleLabel.text = bodyText
            subtitleLabel.textColor = .secondaryLabel
        }
        titleStackView.addArrangedSubview(subtitleLabel)
        
        let spacerView = UIView()
        titleStackView.addArrangedSubview(spacerView)
    }
    
    func setupShiftCards() {
        if !shifts.isEmpty {
            let bodyStackView = UIStackView()
            bodyStackView.axis = .vertical
            bodyStackView.spacing = 17
            mainStackView.addArrangedSubview(bodyStackView)
            
            for shift in shifts {
                let shiftStackView = UIStackView()
                shiftStackView.axis = .horizontal
                shiftStackView.spacing = 1.7
                bodyStackView.addArrangedSubview(shiftStackView)
                
                let relativeLabel = UILabel()
                relativeLabel.text = getRelativeString(for: shift.start).uppercased()
                relativeLabel.font = UIFont.systemFont(ofSize: 14)
                relativeLabel.textColor = .secondaryLabel
                shiftStackView.addArrangedSubview(relativeLabel)
                
                let shiftCardView = UIView()
                shiftCardView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                shiftStackView.addArrangedSubview(shiftCardView)
                
                let shiftCardStackView = UIStackView()
                shiftCardStackView.axis = .horizontal
                shiftCardStackView.spacing = 1.7
                shiftCardView.addSubview(shiftCardStackView)
                shiftCardStackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    shiftCardStackView.topAnchor.constraint(equalTo: shiftCardView.topAnchor),
                    shiftCardStackView.bottomAnchor.constraint(equalTo: shiftCardView.bottomAnchor),
                    shiftCardStackView.leadingAnchor.constraint(equalTo: shiftCardView.leadingAnchor),
                    shiftCardStackView.trailingAnchor.constraint(equalTo: shiftCardView.trailingAnchor)
                ])
                
                let dateLabel = UILabel()
                dateLabel.text = formatDate(date: shift.start)
                dateLabel.font = UIFont.systemFont(ofSize: 16.5, weight: .medium)
                dateLabel.textColor = .black
                shiftCardStackView.addArrangedSubview(dateLabel)
                
                let timeLabel = UILabel()
                timeLabel.text = "\(shift.start.formattedTime()) - \(shift.end.formattedTime()) (\(getIntervalString(timeInterval: shift.duration)))"
                timeLabel.font = UIFont.systemFont(ofSize: 14.5)
                timeLabel.textColor = .black
                timeLabel.text = timeLabel.text?.lowercased()
                shiftCardStackView.addArrangedSubview(timeLabel)
                
                let spacerView = UIView()
                shiftCardStackView.addArrangedSubview(spacerView)
            }
        }
    }

                
                
            
    func setupBody() {
        if !shifts.isEmpty {
            let bodyStackView = UIStackView()
            bodyStackView.axis = .vertical
            bodyStackView.spacing = 17
            mainStackView.addArrangedSubview(bodyStackView)
            
            for shift in shifts {
                let shiftStackView = UIStackView()
                shiftStackView.axis = .horizontal
                shiftStackView.spacing = 1.7
                bodyStackView.addArrangedSubview(shiftStackView)
                
                let relativeLabel = UILabel()
                relativeLabel.text = getRelativeString(for: shift.start).uppercased()
                relativeLabel.font = UIFont.systemFont(ofSize: 14)
                relativeLabel.textColor = .secondaryLabel
                shiftStackView.addArrangedSubview(relativeLabel)
                
                let shiftCardView = UIView()
                shiftCardView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                shiftStackView.addArrangedSubview(shiftCardView)
                
                let shiftCardStackView = UIStackView()
                shiftCardStackView.axis = .horizontal
                shiftCardStackView.spacing = 1.7
                shiftCardView.addSubview(shiftCardStackView)
                shiftCardStackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    shiftCardStackView.topAnchor.constraint(equalTo: shiftCardView.topAnchor),
                    shiftCardStackView.bottomAnchor.constraint(equalTo: shiftCardView.bottomAnchor),
                    shiftCardStackView.leadingAnchor.constraint(equalTo: shiftCardView.leadingAnchor),
                    shiftCardStackView.trailingAnchor.constraint(equalTo: shiftCardView.trailingAnchor)
                ])
                
                let dateLabel = UILabel()
                dateLabel.text = formatDate(date: shift.start)
                dateLabel.font = UIFont.systemFont(ofSize: 16.5, weight: .medium)
                dateLabel.textColor = .black
                shiftCardStackView.addArrangedSubview(dateLabel)
                
                let timeLabel = UILabel()
                timeLabel.text = "\(shift.start.formattedTime()) - \(shift.end.formattedTime()) (\(getIntervalString(timeInterval: shift.duration)))"
                timeLabel.font = UIFont.systemFont(ofSize: 14.5)
                timeLabel.textColor = .black
                timeLabel.text = timeLabel.text?.lowercased()
                shiftCardStackView.addArrangedSubview(timeLabel)
                let spacerView = UIView()
                shiftCardStackView.addArrangedSubview(spacerView)
            }
        }
    }
    
    func setupTotalDuration() {
        if !shifts.isEmpty {
            let totalStackView = UIStackView()
            totalStackView.axis = .horizontal
            mainStackView.addArrangedSubview(totalStackView)
            
            let totalLabel = UILabel()
            totalLabel.text = "The total duration of these shifts is \(getIntervalString(timeInterval: totalDuration(shifts: shifts)))."
            totalLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            totalLabel.numberOfLines = 0
            totalLabel.textColor = .secondaryLabel
            totalLabel.textAlignment = .left
            totalStackView.addArrangedSubview(totalLabel)
            
            let spacerView = UIView()
            totalStackView.addArrangedSubview(spacerView)
        }
    }
    
    func totalDuration(shifts: [HWShift]) -> TimeInterval {
        return shifts.reduce(0) { result, shift in
            return result + shift.duration
        }
    }
    
    func getIntervalString(timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        return formatter.string(from: timeInterval) ?? "Error"
    }
    
    func getRelativeString(for date: Date) -> String {
        let daysUntil = date.daysUntil()
        if daysUntil < 2 {
            return date.userFriendlyRelativeString()
        }
        
        return "IN \(daysUntil) DAYS"
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d"
        return dateFormatter.string(from: date)
    }
    
}
