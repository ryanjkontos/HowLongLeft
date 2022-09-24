//
//  ExtensionPurchaseHostingViewController.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 25/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

class ExtensionPurchaseHostingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let controller = UIHostingController(rootView: ExtensionPurchaseView(type: .widget, presentSheet: .constant(false)))
        
        
        self.view.addSubview(controller.view)
        self.addChild(controller)
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            controller.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            controller.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
        ])
        
        // Do any additional setup after loading the view.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
