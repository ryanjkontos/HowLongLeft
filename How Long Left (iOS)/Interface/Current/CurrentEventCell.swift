//
//  CurrentEventCell.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 31/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class DefaultCurrentEventCell: UITableViewCell, CurrentEventCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    @IBOutlet weak var progressBarTop: UIView!
    @IBOutlet weak var progressBarBottom: UIView!
    
    @IBOutlet weak var progressBarHeight: NSLayoutConstraint!
    
    var event: HLLEvent!
    
    let countdownStringGenerator = CountdownStringGenerator()
    
    func setup(with event: HLLEvent) {
        
        self.event = event
        
        updateCell()
        
        
    }
    
    func updateCell() {
            
            let title = self.event.title.truncated(limit: 18, position: .middle, leader: "...")
            self.titleLabel.text = "\(title) \(self.event.countdownTypeString) in"
            self.countdownLabel.text = self.countdownStringGenerator.generatePositionalCountdown(event: self.event)
        
            self.progressBarTop.backgroundColor = self.event.uiColor
            self.progressBarBottom.backgroundColor = self.event.uiColor.withAlphaComponent(0.25)
            
            let totalHeight = self.progressBarBottom.frame.size.height
            var height = self.event.completionFraction
            height *= Double(totalHeight)
        
            //print("Setting bar height for \(event.title) totalH: \(totalHeight)")
        
            self.progressBarHeight.constant = CGFloat(height)
            
        
        
    }
    

}

class DetailCurrentEventCell: UITableViewCell, CurrentEventCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var progressBarTop: UIView!
    @IBOutlet weak var progressBarBottom: UIView!
    
    @IBOutlet weak var progressBarHeight: NSLayoutConstraint!
    
    var event: HLLEvent!
    
    let countdownStringGenerator = CountdownStringGenerator()
    
    func setup(with event: HLLEvent) {
        
        self.event = event
        updateCell()
        
    }
    
    func updateCell() {
            
        let title = self.event.title.truncated(limit: 18, position: .middle, leader: "...")
        self.titleLabel.text = "\(title) \(self.event.countdownTypeString) in"
        self.countdownLabel.text = self.countdownStringGenerator.generatePositionalCountdown(event: self.event)
                       
        self.progressBarTop.backgroundColor = self.event.uiColor
        self.progressBarBottom.backgroundColor = self.event.uiColor.withAlphaComponent(0.25)
                       
        let totalHeight = self.progressBarBottom.frame.size.height
        var height = self.event.completionFraction
        height *= Double(totalHeight)
        self.progressBarHeight.constant = CGFloat(height)
                       
        print("Setting bar height for \(event.title) \(height)")
        
        infoLabel.text = "(\(event.completionPercentage) Done)"
        
    }
    

}

protocol CurrentEventCell {
    
    var event: HLLEvent! { get set }
    
    func setup(with event: HLLEvent)
    func updateCell()
    
}
