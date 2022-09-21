//
//  ComplicationIAP.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 1/3/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import StoreKit




class IAPHandler: NSObject {
    static let shared = IAPHandler()
    
    static var unreachable = true
    static var delegate: IAPListener?
    
    static var recentTransaction: SKPaymentTransaction?
    
    var complicationPriceCell: TitleDetailCell?
    
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    static var complicationPriceString: String?
    
  //  var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    
    func setPurchasedStatus(_ to: Bool) {
        
        if to == true {
            
            let ID = UIDevice().identifierForVendor!
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let salt = String((0..<6).map{ _ in letters.randomElement()! })
            let hash = "\(ID)-\(salt)"
            
            HLLDefaults.defaults.set(salt, forKey: "ComplicationSalt")
            HLLDefaults.defaults.set(hash, forKey: "ComplicationHash")
            HLLDefaults.complication.complicationPurchased = true
            HLLDefaults.complication.overrideComplicationPurchased = false
            
            
        } else {
            
             HLLDefaults.complication.complicationPurchased = false
            HLLDefaults.defaults.set(nil, forKey: "ComplicationSalt")
            HLLDefaults.defaults.set(nil, forKey: "ComplicationHash")
            
        }
        
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
    }
    
    func hasPurchasedComplication() -> Bool {
        
        if HLLDefaults.complication.overrideComplicationPurchased {
            return HLLDefaults.complication.overridenComplicationPurchasedStatus
        }
        
        if SchoolAnalyser.privSchoolMode == .Magdalene {
            
            print("IAPCheck: Magalene user; Getting complication for free.")
            return true
            
        }
        
        if isReceiptPresent() == false {
            
            setPurchasedStatus(false)
            return false
            
        }
        
        var returnValue = false
        
        if let storedSalt = HLLDefaults.defaults.string(forKey: "ComplicationSalt"), let storedHash = HLLDefaults.defaults.string(forKey: "ComplicationHash") {
            
            let ID = UIDevice().identifierForVendor!
            let newHash = "\(ID)-\(storedSalt)"
            
            if newHash == storedHash {
                
                returnValue = true
                //print("IAPCheck: Hashes did match")
                
            } else {
                
                //print("IAPCheck: Hashes did not match")
                
            }
            
            
        } else {
            
            //print("IAPCheck: Defaults contained nil, didn't check hashes")
            
        }
        
        return returnValue
        
    }
    
    
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(index: Int){
        if iapProducts.count == 0 { return }
        
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        
        
        print("Restore called")
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(){
        
        print("Fetch called")
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects: "ComplicationIAPHLL")
        
        
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

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    // MARK: - REQUEST IAP PRODUCTS
    
    
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts{
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
              //  print("IAP: \(product.localizedDescription) costs \(price1Str!)")
                
                if product.productIdentifier == "ComplicationIAPHLL" {
                    
                    IAPHandler.complicationPriceString = price1Str
                    DispatchQueue.main.async {
                        self.complicationPriceCell?.detailLabel.text = price1Str
                    }
                    NotificationCenter.default.post(name: Notification.Name("gotComplicationPrice"), object: nil)
                    
                }
                
            }
        }
        
        
        
    }
    
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
      //  IAPHandler.delegate?.purchaseResult(was: .restored)
      //  setPurchasedStatus(true)
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
      //  purchaseStatusBlock?(.disabled)
      //  IAPHandler.delegate?.purchaseResult(was: .failed)
       // setPurchasedStatus(false)
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                
             IAPHandler.recentTransaction = trans
                
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                  //  purchaseStatusBlock?(.purchased)
                    setPurchasedStatus(true)
                    IAPHandler.delegate?.purchaseResult(was: .succeeded)
                    
                    break
                    
                case .failed:
                    print("failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    IAPHandler.delegate?.purchaseResult(was: .failed)
                    break
                    
                case .restored:
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    setPurchasedStatus(true)
                    IAPHandler.delegate?.purchaseResult(was: .restored)
                    break
                    
                default: break
                }}}
    }
}

protocol IAPListener {
    
    func purchaseResult(was result: IAPPurchaseState)
    
    
}

enum IAPPurchaseState {
    
    case succeeded
    case failed
    case restored
    
}
