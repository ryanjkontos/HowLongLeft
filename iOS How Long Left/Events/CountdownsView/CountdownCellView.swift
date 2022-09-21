//
//  CountdownCellView.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 27/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit
import Combine

class CountdownCellView: RepesentedEventView {

    let titleLabel = UILabel()
    let statusLabel = UILabel()
    
    let timerLabel = UILabel()
    
    var ac: AnyCancellable?
    
    static let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    override func configureForEvent(event: HLLEvent) {
        
        self.updateCountdownLabel()
        
        ac = CountdownCellView.timer.sink(receiveValue: { _ in
            
            DispatchQueue.main.async {
                
               
                
                self.updateCountdownLabel()
                
               /* if HLLEventSource.shared.eventPool.contains(event), event.completionStatus == .done {
                    
                    self.interaction?.dismissMenu()
                    
                    if let interaction = self.interaction {
                        self.removeInteraction(interaction)
                    }
                    
                    
                    
                    
                } */
                
            } 
            
            
        })
        
        super.configureForEvent(event: event)
        
   
     
     
      
      
        
        self.event = event
        
        updateCountdownLabel()
        
        let col = event.color
       
      
        
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
            gradientLayer.colors = [col.darker(by: 0)!.cgColor, col.darker(by: 10)!.cgColor]
            //gradientLayer.opacity = 0.9
        
    }
    
    override func configure() {
        
        super.configure()
        
      
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        
 
        layer.cornerCurve = .continuous
        layer.cornerRadius = 30.0
        layer.masksToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        addSubview(titleLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        addSubview(statusLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textColor = .white
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .medium)
        addSubview(timerLabel)
        let inset = CGFloat(25)
        let verticalInset = CGFloat(12)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalInset),
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            timerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalInset),
        ])
        
    }
    

    func updateCountdownLabel() {
        
        self.event = event?.getUpdatedInstance()
        
        if let event = event {
            
            titleLabel.text = event.title
            
            statusLabel.text = "\(event.countdownTypeString())"
            self.timerLabel.text = CountdownStringGenerator.shared.generatePositionalCountdown(event: event, at: Date())
            
        } else {
            ac?.cancel()
        }
        
    }
    
  
    
}


class LayerContainerView: UIView {

    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
}
