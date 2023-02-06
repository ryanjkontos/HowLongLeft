//
//  EventFetchPeriod.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 12/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

enum EventFetchPeriod {
    case AllToday
    case UpcomingToday
    case AllTodayPlus24HoursFromNow
    case Next2Weeks
    case ThisYear
    case AnalysisPeriod
    case OneMonthEachSideOfToday
}
