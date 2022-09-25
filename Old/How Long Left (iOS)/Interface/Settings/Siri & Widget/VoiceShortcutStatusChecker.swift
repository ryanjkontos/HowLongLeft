//
//  VoiceShortcutStatusChecker.swift
//  How Long Left
//
//  Created by Ryan Kontos on 28/1/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

#if canImport(Intents)
import Intents
import IntentsUI
#endif

class VoiceShortcutStatusChecker: NSObject {
    
    static let shared = VoiceShortcutStatusChecker()
    
    var delegate: ShortcutDelegate?
    
    var shortcutViewController: UIViewController?
    var statusString = "Not Enabled"
    var phrase: String?
    
    override init() {
        super.init()
        check()
    }
    
    func check() {
        
        #if !targetEnvironment(macCatalyst)
        
        if #available(iOS 12.0, *) {
            
           /* if let shortcutIntent = INShortcut(intent: HowLongLeftIntent()) {
                
                let voiceShortcuts = INVoiceShortcutCenter.shared
                voiceShortcuts.getAllVoiceShortcuts(completion: { shortcuts, error in
                    
                    DispatchQueue.main.async {
                    
                        var shortcutExists = false
                        
                    if let unwrappedShortcutArray = shortcuts {
                        
                        for item in unwrappedShortcutArray {
                            
                            if item.shortcut.userActivity == shortcutIntent.userActivity {
                                
    
                                shortcutExists = true
                                item.shortcut.intent?.suggestedInvocationPhrase = "How Long Left"
                                
                                let controller = INUIEditVoiceShortcutViewController(voiceShortcut: item)
                                controller.delegate = self
                                controller.modalPresentationStyle = .fullScreen
                                self.shortcutViewController = controller
                                self.statusString = "\"\(item.invocationPhrase)\""
                                self.phrase = item.invocationPhrase
                                self.delegate?.shortcutUpdated()
                                return
                                
                            }
                            
                        }
                        
                    }
                        
                        if shortcutExists == false {
                        
                        shortcutIntent.intent?.suggestedInvocationPhrase = "How Long Left"
                        self.statusString = "Not Enabled"
                        self.phrase = nil
                        let controller = INUIAddVoiceShortcutViewController(shortcut: shortcutIntent)
                        controller.delegate = self
                        controller.modalPresentationStyle = .fullScreen
                        self.shortcutViewController = controller
                            
                        }
                        
                    

                    self.delegate?.shortcutUpdated()
                    }
                    
                })
                
            } */
        }
        
        #endif
        
    }
    
    
}


@available(iOS 12.0, *)
extension VoiceShortcutStatusChecker: INUIAddVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        VoiceShortcutStatusChecker.shared.check()
        controller.dismiss(animated: true, completion: nil)
        delegate?.shortcutUpdated()
        
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        VoiceShortcutStatusChecker.shared.check()
        controller.dismiss(animated: true, completion: nil)
        delegate?.shortcutUpdated()
    }
    
}

@available(iOS 12.0, *)
extension VoiceShortcutStatusChecker: INUIEditVoiceShortcutViewControllerDelegate {
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        VoiceShortcutStatusChecker.shared.check()
        controller.dismiss(animated: true, completion: nil)
        delegate?.shortcutUpdated()
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        VoiceShortcutStatusChecker.shared.check()
        controller.dismiss(animated: true, completion: nil)
        delegate?.shortcutUpdated()
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
        delegate?.shortcutUpdated()
    }
    
}
   
