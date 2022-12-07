//
//  LaunchingViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 20/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class LaunchingViewController: UIViewController, EventSourceUpdateObserver {

    var hasSetupView = false
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HLLEventSource.shared.addeventsObserver(self)
        
        timer = Timer(timeInterval: 0.5, target: self, selector: #selector(setupView), userInfo: nil, repeats: false)
    }
    
    func eventsUpdated() {
       setupView()
    }
    
   @objc func setupView() {
        
        if hasSetupView == false {
            hasSetupView = true
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let root = storyboard.instantiateViewController(withIdentifier: "RootView") as! RootViewController
            
            if #available(iOS 13.0, *) {
                self.view.window?.rootViewController = root
                
               
               } else {
                   let appDelegate = UIApplication.shared.delegate as? AppDelegate
                   appDelegate?.window?.rootViewController = root
                   
               }
        
        }
        
    }

}
