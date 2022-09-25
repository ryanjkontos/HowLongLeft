//
//  UpcomingEventsTableRow.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 1/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit

class UpcomingEventsTableRow: UITableViewCell {
    
    var timer: Timer!
    
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startsInTimer: UILabel!
    var rowEvent: HLLEvent!
    let gradient = CAGradientLayer()
    
    @IBOutlet weak var calColBAr: UIView!
    
    func generate(from event: HLLEvent) {
        
       
        startLabel.isHidden = false
        endLabel.isHidden = false
        rowEvent = event
        titleLabel.text = event.title
        startLabel.text = event.startDate.formattedTime()
        endLabel.text = event.endDate.formattedTime()
        
        if event.startDate.formattedDate() != event.endDate.formattedDate() {
            
            endLabel.text = " "
            
        }
        
    
        var infoText: String?
        
        
        
        if var location = rowEvent.location {
            
           /* if location.contains(text: "Room: "), rowEvent.roomChange != nil {
                               
                if let justRoom = location.components(separatedBy: "Room: ").last {
                    
                    location = "Room Change: \(justRoom)"
                    
                }
                
            } */
                                   
            
            infoText = "\(location)"
            locationLabel.isHidden = false
            
            /*if let period = rowEvent.period {
                
                infoText = "\(infoText!) - Period \(period)"
                locationLabel.isHidden = false
                
            } */
            
        } else /* if let period = rowEvent.period {
                
                infoText = "Period \(period)"
                locationLabel.isHidden = false
                
            } else*/ {
                
                locationLabel.isHidden = true
                
            }
        
            
            locationLabel.text = infoText
            
        
        
        calColBAr.backgroundColor = event.color
        
        if event.isAllDay {
            
            endLabel.isHidden = true
            startLabel.text = "All-Day"
            
        }
        
    }
 
    
}
