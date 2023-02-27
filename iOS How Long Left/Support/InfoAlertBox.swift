//
//  InfoAlertBox.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 20/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import UIKit

class InfoAlertBox {
    
    internal init(tabController: HLLTabViewController) {
        self.tabController = tabController
    }
    
    
    static var shared: InfoAlertBox!
    
    private var tabController: HLLTabViewController
    
    private let feedbackGen = UINotificationFeedbackGenerator()
    
    var currentID: UUID?

    
    private var box: UIView {
        return tabController.notifView
    }
    
    private var boxShowing: Bool {
        return box.alpha != 0
    }
    
    func showAlert(imageName: String? = nil, text: String) {
        
        
        DispatchQueue.main.async {
            
            
            self.feedbackGen.prepare()
            self.tabController.notifText.textAlignment = .center
            
            let alertID = UUID()
            self.currentID = alertID
            
            if self.boxShowing {
                
                UIView.animate(withDuration: 0.3, delay: 0, animations: {
                    self.tabController.notifText.text = text
                    self.tabController.notifView.layoutIfNeeded()
                    self.tabController.notifText.layoutIfNeeded()
                    
                })
                
            } else {
                self.tabController.notifText.text = text
            }
            
           
            if !self.boxShowing {
                self.animateIn()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
                    self.feedbackGen.notificationOccurred(.success)
                }
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                if self.currentID != alertID { return }
                self.animateOut()
                
            }
        }
        
        
    }
    
    private func animateIn() {
        
        
        
        tabController.notifView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)

        // Animate the view with a fade in and scale up effect
        UIView.animate(withDuration: 0.55, delay: 0.13, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.curveEaseIn], animations: {
            self.box.alpha = 1.0
            self.box.transform = CGAffineTransform.identity
        })
        
    }
    
    private func animateOut() {
            
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.box.alpha = 0
            self.box.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
        
    }
    
}
