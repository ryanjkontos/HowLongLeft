//
//  PurchaseProViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 6/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa
import Preferences

final class PurchaseProViewController: NSViewController, PreferencePane {
    
    @IBOutlet weak var buyButton: NSButton!
    @IBOutlet weak var restoreButton: NSButton!
    @IBOutlet weak var spinner: NSProgressIndicator!
    
    @IBOutlet weak var overrideSwitch: NSButton!
    
    @IBOutlet weak var desLabel: NSTextField!
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.purchasePro
    var preferencePaneTitle: String = "Pro"
    
    let toolbarItemIcon = PreferencesGlobals.proImage
    
    let infoStoryboard = NSStoryboard(name: "ProOnboarding", bundle: nil)
    
    override var nibName: NSNib.Name? {
        return "PurchasePro"
    }
    
    override func viewDidLoad() {
         
        self.preferredContentSize = CGSize(width: 528, height: 400)
        showSpinner(false)
        
           
    }

    @IBAction func switchClicked(_ sender: NSButton) {
        
        ProStatusManager.shared.setOveride(sender.state.isOn)
    }
    
    override func viewWillAppear() {
        
        desLabel.stringValue = ProInfoStringGenerator.shared.generateProInfoString(isForOnboarding: false)
        
        buyButton.title = "Buy"
        
        if let price = ProPurchaseHandler.shared.proPrice {
            buyButton.title = "Buy – \(price)"
        }
        
        ProPurchaseHandler.shared.paymentUIDelegate = self
    }
    
    @IBAction func buyButtonClicked(_ sender: NSButton) {
        showSpinner(true)
        ProPurchaseHandler.shared.purchaseMyProduct(index: 0)
    }
    
    
    @IBAction func restoreClicked(_ sender: NSButton) {
        
        ProPurchaseHandler.shared.restorePurchase()
        
    }
    
    
    func showSpinner(_ shown: Bool) {
    
        DispatchQueue.main.async {
        
            self.buyButton.isHidden = shown
            self.restoreButton.isHidden = shown
            self.spinner.isHidden = !shown
            self.spinner.startAnimation(nil)
            
        }
        
    }
    
    
    @IBAction func moreInfoClicked(_ sender: NSButton) {
        
        let vc = (infoStoryboard.instantiateController(withIdentifier: "InfoContainerView") as! NSViewController)
        self.presentAsSheet(vc)
        
    }
    
    

}

extension PurchaseProViewController: HLLMacPaymentUIDelegate {
    
    func purchaseInitiated() {
        showSpinner(true)
    }
    
    func purchaseCompleted(with result: HLLMacPaymentResult) {
        showSpinner(false)
    }
    
    func restoreFailed() {
        showSpinner(false)
    }
    
}
