//
//  ProStatusManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 7/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import CoreData

class ProStatusManager {
    
    public var isPro: Bool {
        
        get {
        
          
            return true
            return self.hasPurchasedPro
            
            
        }
        
    }
    
    
    private var statusObservers = [HLLProStatusObserver]()
    static var shared = ProStatusManager()
    
    static var hasFinishedInit = false
    
    private var hasPurchasedPro = false
   
    var statusItemText: String?
    
    
    
    // MARK: Public Interface
    
    init() {
      //  HLLEventSource.shared.addEventPoolObserver(self)
        
        updateProStatus()
        ProStatusManager.hasFinishedInit = true
        
    }
    
    func addStatusObserver(_ observer: HLLProStatusObserver) {
        
        self.statusObservers.append(observer)
        
    }
    
    func setProStatus(_ newStatus: Bool) {
     
        DispatchQueue.main.async {
        
        #if os(OSX)
        
            let context = HLLDataModel.shared.persistentContainer.viewContext
        
            for purchase in self.fetchProPurchase() {
            
            context.delete(purchase)
            
        }
        
        if newStatus == true {
         
        let record = NSEntityDescription.insertNewObject(forEntityName: "ProPurchase", into: context) as! ProPurchase
        record.purchaseID = ProValidator.shared.getProPurchaseID()
            
         
        }
            
        DispatchQueue.main.async {
            self.updateProStatus()
        }
        
        DispatchQueue.main.async {
            try! context.save()
        }
        
        #endif
            
        }
        
    }
    
    func setOveride(_ value: Bool) {
        
        HLLDefaults.defaults.set(value, forKey: "Proveride")
        
        
        DispatchQueue.main.async {
            self.updateProStatus()
        }
        HLLEventSource.shared.asyncUpdateEventPool()
        
    }

    
    // MARK: Private Interface
    
     func updateProStatus() {

        
        var newStatus = false
        
            if let purchase = self.fetchProPurchase().first {
            
          //  print("Got first pro purchase")
            
            if purchase.isValid() {
                
                newStatus = true
            }
            
            }
            
        
    
      //  print("Pro status is now \(newStatus)")
        
        
        
        let previous = self.hasPurchasedPro
        
        if previous != newStatus {

            DispatchQueue.main.async {
                
                
                self.statusObservers.forEach({$0.proStatusChanged(from: previous, to: newStatus)})
                
                
            }
            
            self.hasPurchasedPro = newStatus
            HLLDefaults.appData.proUser = self.isPro
            
            if ProStatusManager.hasFinishedInit {
            
            HLLEventSource.shared.asyncUpdateEventPool()
                
            }
            
            
            
        }
            
        
        
    }
    
    private func fetchProPurchase() -> [ProPurchase] {
          
        var returnArray = [ProPurchase]()
        
        let managedContext = HLLDataModel.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProPurchase> = ProPurchase.fetchRequest()
        if let items = try? managedContext.fetch(fetchRequest) {
            returnArray = items
        }
        
        return returnArray
        
    }

    var doneMagdaleneNoto = false
    
}

extension ProStatusManager: EventPoolUpdateObserver {
    
    func eventPoolUpdated() {
        
        if self.hasPurchasedPro != self.isPro {
            
            if doneMagdaleneNoto == false {
            
                doneMagdaleneNoto = true
            self.statusObservers.forEach({$0.proStatusChanged(from: self.isPro, to: self.isPro)})
                
            }
        }
        
        
    }
    
}

protocol HLLProStatusObserver {
    
    func proStatusChanged(from previousStatus: Bool, to newStatus: Bool)
    
}
