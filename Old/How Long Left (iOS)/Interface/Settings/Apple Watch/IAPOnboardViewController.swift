//
//  IAPOnboardViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 13/4/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit
import Foundation


class IAPRootView: UIViewController, IAPListener {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var purchaseActionStack: UIStackView!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var restoreActivityIndicator: UIActivityIndicatorView!
    var activityIndicator: UIActivityIndicatorView?
    var delegateTable: UITableViewController?
    var configureForPreview = false

    var originalButtonText: String!
    
    
    var isPurchasing = false
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "Complication"
        
        purchaseActionStack.isHidden = configureForPreview
        
        if self.navigationController == nil {
            cancelButton.isHidden = false
        } else {
            cancelButton.isHidden = true
        }
    
        if configureForPreview {
            cancelButton.isHidden = true
        }
        
        if let price = IAPHandler.complicationPriceString {
        originalButtonText = "Buy - \(price)"
        } else {
        originalButtonText = "Buy - Price Unavailable"
        }
        
        self.buyButton.layer.cornerRadius = 8.0
        self.buyButton.layer.masksToBounds = true
        
        self.buyButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        self.buyButton.setTitle(originalButtonText, for: .normal)
        
       // self.buyButton.setBackgroundImage(image, for: .normal)
        
        restoreActivityIndicator.isHidden = true
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if configureForPreview == false {
        self.delegateTable?.tableView.reloadData()
        }
    }
    
    func purchaseResult(was result: IAPPurchaseState) {
        
        isPurchasing = false
        
        hideLoading()
        
        restoreButton.isHidden = false
        restoreActivityIndicator.isHidden = true
        
        restoreActivityIndicator.stopAnimating()
        

        
        switch result {
            
        case .succeeded:
            
            SettingsMainTableViewController.justPurchasedComplication = true
            
            RootViewController.shared?.showComplicationPurchasedAlert(purchasedNow: true)
            
            self.dismiss(animated: true, completion: nil)
            
            
            
        case .failed:
            
            RootViewController.shared?.showComplicationPurchasedFailedAlert()
            
            self.dismiss(animated: true, completion: nil)
         
        case .restored:
            
          // RootViewController.shared?.showComplicationPurchasedAlert(purchasedNow: true, restored: true)
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
        
    }
    
    @IBAction func buyTapped(_ sender: UIButton) {
        
        if isPurchasing == false {
        
            isPurchasing = true
            
        IAPHandler.delegate = self
        
        IAPHandler.shared.purchaseMyProduct(index: 0)
        
        showLoading()
            
        }
    
        
            
    }
    
    @IBAction func restoreTapped(_ sender: UIButton) {
        
        if isPurchasing == false {
        
            isPurchasing = true
            
        
        restoreActivityIndicator.startAnimating()
        
            restoreButton.isHidden = true
            restoreActivityIndicator.isHidden = false
            
        IAPHandler.delegate = self
        
        IAPHandler.shared.restorePurchase()
            
        }
        
        
    }
    
    
    func showLoading() {
        buyButton.setTitle("", for: .normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        buyButton.setTitle(originalButtonText, for: .normal)
        activityIndicator?.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        buyButton.addSubview(activityIndicator!)
        centerActivityIndicatorInButton()
        activityIndicator?.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: buyButton!, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        buyButton.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: buyButton!, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        buyButton.addConstraint(yCenterConstraint)
    }
    
}
