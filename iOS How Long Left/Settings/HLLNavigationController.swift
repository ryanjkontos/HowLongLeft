//
//  HLLNavigationController.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 24/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class HLLNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        var animate = animated
        #if targetEnvironment(macCatalyst)
            animate = false
        #endif
        
        super.pushViewController(viewController, animated: animate)
        
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        var animate = animated
        #if targetEnvironment(macCatalyst)
            animate = false
        #endif
        return super.popViewController(animated: animate)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        var animate = animated
        #if targetEnvironment(macCatalyst)
            animate = false
        #endif
        return super.popToRootViewController(animated: animate)
    }
    
    

}
