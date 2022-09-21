//
//  RenameIntroViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 12/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class RenameIntroViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.continueButton.layer.cornerRadius = 13.0
               self.continueButton.layer.masksToBounds = true
               
        self.continueButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        
        
    }
    
    @IBAction func cancellTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "RenameConfigView")
        
        self.navigationController?.pushViewController(view, animated: true)
        
    }
    
}

class RenameConfigurationViewController: UIViewController {
    
    @IBAction func cancellTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
