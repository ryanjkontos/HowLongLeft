//
//  ProOnboardingViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 25/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa

class ProOnboardingViewController: NSViewController {

    let infoStoryboard = NSStoryboard(name: "ProOnboarding", bundle: nil)
    
    @IBOutlet weak var buyButton: NSTextField!
    var spinner: NSProgressIndicator!
    
    @IBOutlet weak var bottomBox: NSBox!
    @IBOutlet weak var purchaseButton: PurchaseButton!
    
    @IBOutlet weak var infoField: NSTextField!
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
       // self.showSpinner(false)
        buyButton.stringValue = "Buy"
        
        infoField.stringValue = ProInfoStringGenerator.shared.generateProInfoString(isForOnboarding: true)
        
        if let price = ProPurchaseHandler.shared.proPrice {
            buyButton.stringValue = "\(price)"
        }
        
        ProPurchaseHandler.shared.paymentUIDelegate = self
        purchaseButton.delegate = self
        
        
        
        spinner = NSProgressIndicator(frame: NSRect(origin: CGPoint(), size: CGSize(width: 15, height: 15)))
                   spinner.style = .spinning
                   spinner.isIndeterminate = true
                   spinner.startAnimation(nil)
                   let subviewWidth = spinner.frame.width
                   let subviewHeight = spinner.frame.height
                   
                   let x = (self.purchaseButton.bounds.width - subviewWidth) * 0.5
                   let y = (self.purchaseButton.bounds.height - subviewHeight) * 0.5
                   let f = CGRect(x: x, y: y, width: subviewWidth, height: subviewHeight)
                   
                   spinner.frame = f
                   spinner.autoresizingMask = [.minXMargin, .maxXMargin, .minYMargin, .maxYMargin ]
        
        spinner.isHidden = true
                   
        self.purchaseButton.addSubview(spinner)
              
        
    }
    
    
    @IBAction func learnMoreClicked(_ sender: NSButton) {
        
        let vc = (infoStoryboard.instantiateController(withIdentifier: "InfoContainerView") as! NSViewController)
        self.presentAsSheet(vc)
        
        
        
        
    }
    
    
    func purchaseClicked() {
        print("Purchase clicked")
        ProPurchaseHandler.shared.purchaseMyProduct(index: 0)
        showSpinner(true)
        
        
    }
    
    
    
    override func viewWillDisappear() {
         purchaseButton.delegate = nil
    }
  
    @IBAction func restoreClicked(_ sender: NSButton) {
        
     //   showSpinner(true)
        ProPurchaseHandler.shared.restorePurchase()
        
    }
    func showSpinner(_ shown: Bool) {
    
        buyButton.isHidden = shown
        spinner.isHidden = !shown
        
    }
    
}

class PurchaseButton: NSBox {
    
    var delegate: ProOnboardingViewController?
    
    override func display() {
        self.fillColor = buttonColour
    }
    
    
    let buttonColour = NSColor.init(named: "ProButtonColour")!
    let selectedButtonColour = NSColor.init(named: "SelectedProButtonColour")!
    
    override func mouseDown(with event: NSEvent) {
        
        self.fillColor = selectedButtonColour
        delegate?.purchaseClicked()
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
        self.fillColor = buttonColour
        
    }
    
    
}

extension ProOnboardingViewController: HLLMacPaymentUIDelegate {

func purchaseInitiated() {
    
    
   showSpinner(true)
        
    
}

func purchaseCompleted(with result: HLLMacPaymentResult) {
    
    
   showSpinner(false)
    
    if result != .fail {
        self.view.window?.close()
    }
    
}

func restoreFailed() {
    showSpinner(false)
}
    
}


class ProWindowBackgroundView: NSView {

  
    override func draw(_ dirtyRect: NSRect) {
        self.wantsLayer = true
        


               self.window?.isOpaque = false
               self.window?.alphaValue = 0.98
               
               let blurView = NSVisualEffectView(frame: self.bounds)
               blurView.wantsLayer = true
               blurView.blendingMode = .behindWindow
               if #available(OSX 10.14, *) {
                   blurView.material = .fullScreenUI
               }
               blurView.state = .active
               self.addSubview(blurView)
    }
    
    

}

extension NSView {
    var isDarkMode: Bool {
        if #available(OSX 10.14, *) {
            if effectiveAppearance.name == .darkAqua {
                return true
            }
        }
        return false
    }
}

class InfoViewViewController: NSViewController {
    
    
    @IBOutlet weak var infoScrollView: NSScrollView!
    
    let infoStoryboard = NSStoryboard(name: "ProOnboarding", bundle: nil)
    var vc: NSViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        
        vc = (infoStoryboard.instantiateController(withIdentifier: "InfoContentView") as! NSViewController)
        
        infoScrollView.documentView = vc.view
        infoScrollView.scrollerInsets = NSEdgeInsets(top: 0, left: 0, bottom: 54, right: 0)
        
        if let documentView = infoScrollView.documentView {
            documentView.scroll(NSPoint(x: 0, y: documentView.bounds.size.height))
        }
       
        
        
    }
    
    
}

class FlippedView: NSView {
    override var isFlipped: Bool { return true }
}

class InfoContainerViewController: NSViewController {
    
    
    @IBOutlet weak var doneButton: NSButton!
    
    @IBAction func doneClicked(_ sender: NSButton) {
        
        self.dismiss(nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        doneButton.window?.initialFirstResponder = doneButton
        doneButton.becomeFirstResponder()
        
    }
    
    
    
}
