//
//  ReferenceDateStringGenerator.swift
//  How Long Left watch App WatchKit Extension
//
//  Created by Ryan Kontos on 25/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import Combine

class ReferenceDateStringGenerator {
    var referenceDate: Date
    var stringGetters: [(Date) -> String]

    let show = 2.5
    
    init(referenceDate: Date, stringGetters: [(Date) -> String]) {
        self.referenceDate = referenceDate
        self.stringGetters = stringGetters
    }

    func string(for date: Date) -> String {
        let index = Int(date.timeIntervalSince(referenceDate) / show) % stringGetters.count
        return stringGetters[index](date)
    }
}
