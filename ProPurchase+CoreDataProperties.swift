//
//  ProPurchase+CoreDataProperties.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 16/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//
//

import Foundation

import CoreData


extension ProPurchase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProPurchase> {
        return NSFetchRequest<ProPurchase>(entityName: "ProPurchase")
    }

    @NSManaged public var purchaseID: String?

}
