//
//  HLLHiddenEvent+CoreDataProperties.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 27/5/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//
//

import Foundation
import CoreData


extension HLLStoredEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HLLStoredEvent> {
        return NSFetchRequest<HLLStoredEvent>(entityName: "HLLStoredEvent")
    }

    @NSManaged public var calendarIdentifier: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var identifier: String?
    @NSManaged public var title: String?

}
