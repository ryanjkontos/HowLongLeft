//
//  ComplicationStateManager.swift
//  How Long Left
//
//  Created by Ryan Kontos on 27/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation



class ComplicationStateManager: HLLWCDataObserver {
   
    static var shared = ComplicationStateManager()
    
    typealias ClosureType = ((Bool) -> Void)
    
    var complicationPurchased: Bool {
        return HLLDefaults.complication.complicationPurchased
    }
    
    private var closures = [ClosureType]()
    
    func addClosure(closure: @escaping ClosureType) {
        closures.append(closure)
    }
    
    private func removeClosure(closure: ClosureType) {
        if let index = closures.firstIndex(where: { $0 as AnyObject === closure as AnyObject }) {
            closures.remove(at: index)
        }
    }
    
   private func executeClosures() {
        for closure in closures {
            closure(complicationPurchased)
        }
    }
    
    init() {
        HLLWCDataReceiver.shared.register(self, forKey: complicationActivatedKey)
    }
    
    func handleWCData(object: Any, for key: String) {
        
        guard key == complicationActivatedKey else { return }
        guard let result = object as? Bool else { return }
        if result { HLLDefaults.complication.complicationPurchased = true }
        ComplicationController.updateComplications(forced: false)
        
        
        
    }
    
    func updateForCloud() {
        
        if HLLDefaults.cloudDefaults.bool(forKey: complicationActivatedKey) == true {
            HLLDefaults.complication.complicationPurchased = true
            ComplicationStatusLogger.log("\(Date().formattedTime()): Enabled complication from cloud!")
        }
         
        ComplicationController.updateComplications(forced: false)
    }
    

    
    
}


