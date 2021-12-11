//
//  MagdaleneModeSetupDoneViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 26/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa

/*
class MagdaleneModeSetupDoneViewController: NSViewController {

    @IBOutlet weak var animationView: AnimationView!
    
    override func viewWillAppear() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear() {
        playDoneAnimation()
    }
    
   func playDoneAnimation() {
          DispatchQueue.main.async {
              
              self.animationView.animation = Animation.named("DoneAnimation")!
              self.animationView.loopMode = .playOnce
              self.animationView.play()
              
          }
          
      }
    
    @IBAction func doneButtonClicked(_ sender: NSButton) {
        
        self.view.window?.performClose(nil)
    }
    
    @IBAction func openMagdalenePreferencesClicked(_ sender: NSButton) {
        
        self.view.window?.performClose(nil)
        PreferencesWindowManager.shared.launchPreferences(with: .magdalene, center: true)
        
    }
    
    
}
*/
