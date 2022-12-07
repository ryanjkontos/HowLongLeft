//
//  ProPurchase+CoreDataClass.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 16/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//
//

import Foundation

import CoreData
import CommonCrypto


public class ProPurchase: NSManagedObject {

    func isValid() -> Bool {
        
        #if os(OSX)
        
      //  // print("Stored ID is: \(self.purchaseID!)")
      //  // print("System ID is: \(ProValidator.shared.getProPurchaseID())")
        
        return self.purchaseID == ProValidator.shared.getProPurchaseID()
        
        #else
        
        return false
        #endif
    }
    
    
}
