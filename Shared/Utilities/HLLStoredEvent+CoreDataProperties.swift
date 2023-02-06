//
//  HLLStoredEvent+CoreDataProperties.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 14/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
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
    @NSManaged public var isHidden: Bool
    @NSManaged public var isPinned: Bool
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String?

}

extension HLLStoredEvent : Identifiable {

}
