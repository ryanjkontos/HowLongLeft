//
//  TimerCell.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 10/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class TimerCell: UITableViewCell {
    
    var timer: Timer!
    let timerStringGenerator = CountdownStringGenerator()
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
    var event: HLLEvent!
    
    func setup(with event: HLLEvent) {
        
        self.event = event
        
        mainLabel.font = UIFont.monospacedDigitSystemFont(ofSize: mainLabel.font.pointSize, weight: .medium)
        
        mainLabel.textColor = event.color
        
        mainLabel.layer.shadowColor = UIColor.black.cgColor
        mainLabel.layer.shadowRadius = 3.0
        mainLabel.layer.shadowOpacity = 0.10
        mainLabel.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        mainLabel.layer.masksToBounds = false
        
        updateTimer()
            
            
            timer = Timer(fire: Date(), interval: 0.5, repeats: true, block: {_ in
                
                DispatchQueue.main.async {
                    self.updateTimer()
                }
                
            })
            
            RunLoop.main.add(timer, forMode: .common)
            
        }
        
        func updateTimer() {
            
            if event.completionStatus != .done {
            
                topLabel.text = "\(event.truncatedTitle(15)) \(event.countdownTypeString)"
                let countdownString = self.timerStringGenerator.generatePositionalCountdown(event: event)
                self.mainLabel.text = "\(countdownString)"
                
            } else {
                
                topLabel.text = "\(event.title) is"
                self.mainLabel.text = "Done"
                
            }
          
        }
    
}
