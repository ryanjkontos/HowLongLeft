//
//  Store.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 22/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation
import StoreKit

typealias Transaction = StoreKit.Transaction
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

class Store: ObservableObject {
    
    @Published var complicationProduct: Product?
    @Published var widgetProduct: Product?
    
    @Published private(set) var purchasedExtenions = Set<ExtensionType>()
    
    func hasPurchased(_ type: ExtensionType) -> Bool {
        return purchasedExtenions.contains(type)
    }
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    var products: [Product] {
        
        get {
            
            return [complicationProduct, widgetProduct].compactMap({$0})
            
        }
        
    }
    
    func productFor(_ type: ExtensionType) -> Product? {
        
        switch type {
        case .complication:
            return complicationProduct
        case .widget:
            return widgetProduct
        }
        
    }
    
    init() {
        
        updateListenerTask = listenForTransactions()
        
        Task {
            await requestProducts()
            await refreshPurchasedProducts()
        }
        
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    

    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions which didn't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    //Deliver content to the user.
                     self.updatePurchasedIdentifiers(transaction)

                    //Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }


    @MainActor
    func requestProducts() async {
        do {
           
            let storeProducts = try await Product.products(for: ExtensionType.allCases.map({$0.rawValue}))

            for product in storeProducts {
                
                if let type = ExtensionType(rawValue: product.id) {
                    
                    switch type {
                    case .complication:
                        complicationProduct = product
                    case .widget:
                        widgetProduct = product
                    }
                    
                }
                
            }
           
        } catch {
            print("Failed product request: \(error)")
        }
          
    }
    
    @MainActor
    func purchase(_ product: Product) async throws -> Transaction? {
        //Begin a purchase.
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)

            //Deliver content to the user.
             updatePurchasedIdentifiers(transaction)

            //Always finish a transaction.
            await transaction.finish()

            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func isPurchased(_ productIdentifier: String) async throws -> Bool {
        //Get the most recent transaction receipt for this `productIdentifier`.
        guard let result = await Transaction.latest(for: productIdentifier) else {
            //If there is no latest transaction, the product has not been purchased.
            return false
        }

        let transaction = try checkVerified(result)

        //Ignore revoked transactions, they're no longer purchased.

        //For subscriptions, a user can upgrade in the middle of their subscription period. The lower service
        //tier will then have the `isUpgraded` flag set and there will be a new transaction for the higher service
        //tier. Ignore the lower service tier transactions which have been upgraded.
        return transaction.revocationDate == nil && !transaction.isUpgraded
    }


    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //Check if the transaction passes Storelit verification.
        switch result {
        case .unverified:
            //StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case .verified(let safe):
            //If the transaction is verified, unwrap and return it.
            return safe
        }
    }
    
    
    
    


    func updatePurchasedIdentifiers(_ transaction: Transaction) {
        
        print("Updating purchase ID")
        
        DispatchQueue.main.async {
        
        
        if let extensionType = ExtensionType(rawValue: transaction.productID) {
            if transaction.revocationDate == nil {
                //If the App Store has not revoked the transaction, add it to the list of `purchasedIdentifiers`.
                
                
                
                self.purchasedExtenions.insert(extensionType)
            } else {
                //If the App Store has revoked this transaction, remove it from the list of `purchasedIdentifiers`.
                self.purchasedExtenions.remove(extensionType)
            }
            
        }
        }
    }

    fileprivate func refreshPurchasedProducts() async {
        //Iterate through all of the user's purchased products.
        for await result in Transaction.currentEntitlements {
            //Don't operate on this transaction if it's not verified.
            if case .verified(let transaction) = result {
                //Check the `productType` of the transaction and get the corresponding product from the store.
                switch transaction.productType {
                case .nonConsumable:
                    updatePurchasedIdentifiers(transaction)
                default:
                    //This type of product isn't displayed in this view.
                    break
                }
            }
        }

    }

    
}

public enum StoreError: Error {
    case failedVerification
}
