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
    
    static var shared: Store!
    
    var complicationProduct: Product?
    var widgetProduct: Product?
    
    @Published var widgetPurchased: Bool
    @Published var complicationPurchased: Bool
    
    let complicationPurchasedOldVersionKey = "ComplicationPurchasedOldVersionKey"
    
    func extensionPurchased(oftype type: ExtensionType) -> Bool {
        
        switch type {
        case .widget:
            return widgetPurchased
        case .complication:
            return complicationPurchased
        }
        
    }
    
    private var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        
        var complication = HLLDefaults.premiumPurchases.complication
        if HLLDefaults.defaults.string(forKey: "ComplicationHash") != nil {
            HLLDefaults.defaults.set(nil, forKey: "ComplicationHash")
            HLLDefaults.defaults.set(true, forKey: complicationPurchasedOldVersionKey)
            complication = true
        }
        
        complicationPurchased = complication
        widgetPurchased = HLLDefaults.premiumPurchases.widget
        
        updateListenerTask = listenForTransactions()
        
        Task {
            await requestProducts()
            await refreshPurchasedProducts()
        }
        
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    

    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions which didn't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    //Deliver content to the user.
                     

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
    private func requestProducts() async {
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
    func purchase(productFor extensionType: ExtensionType) async -> Bool {
        

        var transaction: Transaction?
                
                    switch extensionType {
                    case .widget:
                        if let widgetProduct = widgetProduct {
                            transaction = try? await purchase(widgetProduct)
                        }
                    case .complication:
                        if let complicationProduct = complicationProduct {
                            transaction = try? await purchase(complicationProduct)
                        }
                    }
        
        
        return transaction != nil
        
    }
    
    @MainActor
   private func purchase(_ product: Product) async throws -> Transaction? {
        //Begin a purchase.
        
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)

            //Always finish a transaction.
            await transaction.finish()
            
            await refreshPurchasedProducts()

            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    private func isPurchased(_ productIdentifier: String) async throws -> TransactionCheckResult {
        //Get the most recent transaction receipt for this `productIdentifier`.
        guard let result = await Transaction.latest(for: productIdentifier) else {
            //If there is no latest transaction, the product has not been purchased.
            return .unsureNo
        }

        let transaction = try checkVerified(result)

        
        
        if transaction.revocationDate != nil {
            return .revoked
        }
        
        return .purchased
    }


    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
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

    
    @MainActor
    func refreshPurchasedProducts() async {
        
        await checkTransaction(complicationProduct)
        await checkTransaction(widgetProduct)

    }

    @MainActor
    private func checkTransaction(_ product: Product?) async {
        
        guard let product = product else { return }
        guard let type = ExtensionType(rawValue: product.id) else { return }
        guard let result = await product.currentEntitlement, case .verified(let transaction) = result else {
            setPurchased(type: type, .revoked)
            return
        }
        
        HLLDefaults.defaults.set(false, forKey: complicationPurchasedOldVersionKey)
        
        print("Transaction type: \(transaction.productType)")
        
        switch transaction.productType {
        case .nonConsumable:
            let isPurchased = (try? await isPurchased(transaction.productID)) ?? .unsureNo
            
            print("Is Purchased \(type): \(isPurchased)")
            
            setPurchased(type: type, isPurchased)
        default:
            break
        }
        
    }
    
    private func setPurchased(type: ExtensionType, _ result: TransactionCheckResult) {
        
        var state: Bool
        
        switch type {
        case .widget:
            state = HLLDefaults.premiumPurchases.widget
        case .complication:
            state = HLLDefaults.premiumPurchases.complication
        }
        
        switch result {
        case .purchased:
            state = true
        case .unsureNo:
            break
        case .revoked:
            state = false
        }
        
        switch type {
        case .widget:
            HLLDefaults.premiumPurchases.widget = state
        case .complication:
            
            if HLLDefaults.defaults.bool(forKey: complicationPurchasedOldVersionKey) {
                state = true
            }
            
            HLLDefaults.premiumPurchases.complication = state
        }
        
        self.widgetPurchased = HLLDefaults.premiumPurchases.widget
        self.complicationPurchased = HLLDefaults.premiumPurchases.complication
        
    }
    
    func restore() async {
        
        try? await AppStore.sync()
        await refreshPurchasedProducts()
        
    }
    
    enum TransactionCheckResult {
        case purchased
        case unsureNo
        case revoked
    }
    
}



public enum StoreError: Error {
    case failedVerification
}


