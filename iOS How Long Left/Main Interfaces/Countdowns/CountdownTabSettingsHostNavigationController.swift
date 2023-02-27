//
//  CountdownTabSettingsHostNavigationController.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import UIKit

class CountdownTabSettingsHostNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Countdown Tab Settings"
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func close() {
        
        self.dismiss(animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewControllers.first!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
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
