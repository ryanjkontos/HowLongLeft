//
//  ProPurchaseHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 6/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import StoreKit

protocol HLLMacPaymentUIDelegate {
    
    func purchaseInitiated()
    func purchaseCompleted(with result: HLLMacPaymentResult)
    func restoreFailed()
    
}

enum HLLMacPaymentResult {
    case success
    case fail
    case restored
    case cancelled
}


class ProPurchaseHandler: NSObject {
    
    static let shared = ProPurchaseHandler()
    
    static var unreachable = true
    var paymentUIDelegate: HLLMacPaymentUIDelegate?
    
    static var recentTransaction: SKPaymentTransaction?
    
    var proPrice: String?

    var priceDelegatess = [ProPriceDelegate]()
    
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    let proIdentifier = "HLLMacPro"
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(index: Int){
        if iapProducts.count == 0 { return }
        
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            //NSApp.activate(ignoringOtherApps: true)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
        } else {
            
        }
    }
    
    func addPriceDelegate(_ delegate: ProPriceDelegate) {
        
        self.priceDelegatess.append(delegate)
        
        if self.proPrice != nil {
            delegate.proPriceUpdated()
        }
        
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        
        
        print("Restore called")
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        //NSApp.activate(ignoringOtherApps: true)
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(){
        
    //    print("Fetch called")
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects: proIdentifier)
        
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
   func isReceiptPresent() -> Bool {
     if let receiptUrl = Bundle.main.appStoreReceiptURL,
       let canReach = try? receiptUrl.checkResourceIsReachable(),
       canReach {
       return true
     }
     
     return false
   }
    
    
}

extension ProPurchaseHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    // MARK: - REQUEST IAP PRODUCTS
    
    
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts{
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                let locale = Locale.current
                numberFormatter.locale = locale
                //let priceString = numberFormatter.string(from: product.price)
                
                if product.productIdentifier == proIdentifier {
                    self.proPrice = numberFormatter.string(from: product.price)
                    priceDelegatess.forEach({ $0.proPriceUpdated() })
                }
                
          //      print("IAP: \(product.localizedTitle) costs \(priceString!) \(locale.currencyCode!)")
                
            }
        }
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        print("restore finished")
        
        DispatchQueue.main.async {
        
            self.paymentUIDelegate?.purchaseCompleted(with: .restored)
            
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
        DispatchQueue.main.async {
        
            self.paymentUIDelegate?.restoreFailed()
            
        }
        
        DispatchQueue.main.async {
        
        let modal = NSAlert()
        modal.messageText = "Restore Failed"
        modal.informativeText = error.localizedDescription
        modal.window.title = "How Long Left"
        NSApp.activate(ignoringOtherApps: true)
        modal.runModal()
        
            
        }
        
        

    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                
             ProPurchaseHandler.recentTransaction = trans
                
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)

                    DispatchQueue.main.async {
                    
                        self.paymentUIDelegate?.purchaseCompleted(with: .success)
                        
                    }
                    
                    ProStatusManager.shared.setProStatus(true)
                    
                    showGoneProAlert()
                    
                    break
                    
                case .failed:
                    print("failed")
                    
                    DispatchQueue.main.async {
                    
                        self.paymentUIDelegate?.purchaseCompleted(with: .fail)
                        
                    }
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    var usefulError: String? = "An unknown error occured."
                    
                    
                    
                    if let error = trans.error {
                        
                        if let skError = error as? SKError {
                            if skError.code == .paymentCancelled {
                                break
                            }
                        }
  
                        
                        usefulError = error.localizedDescription
                            
                        
                    }
                    
                   
                    
                    
                    
                    if let text = usefulError {
                    
                    DispatchQueue.main.async {
                    
                    let modal = NSAlert()
                    modal.messageText = "Purchase Failed"
                    modal.informativeText = "\(text)"
                    modal.window.title = "How Long Left"
                    NSApp.activate(ignoringOtherApps: true)
                    modal.runModal()
                    
                        
                    }
                    }

                    
                    
                    break
                    
                case .restored:
                    
                    print("restored")
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    DispatchQueue.main.async {
                    
                        self.paymentUIDelegate?.purchaseCompleted(with: .restored)
                        
                    }
                    ProStatusManager.shared.setProStatus(true)
                    showGoneProAlert(restored: true)
                    break
                    
                default: break
                }}}
    }
    
    func showGoneProAlert(restored: Bool = false) {
        
        DispatchQueue.main.async {
                         
            var text = "How Long Left Pro is now enabled"
            var subtitle = "Thanks for going Pro!"
            if restored {
                text = "How Long Left Pro has been restored"
                subtitle = ""
            }
            
                let modal = NSAlert()
                modal.messageText = text
                modal.informativeText = subtitle
                modal.window.title = "How Long Left"
                NSApp.activate(ignoringOtherApps: true)
                modal.runModal()
                
                             
                         }
        
        
    }
    
}


enum IAPPurchaseState {
    
    case succeeded
    case failed
    case restored
    
}


enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}

protocol ProPriceDelegate {
    
    func proPriceUpdated()
    
}
