//
//  HLLDefaults.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 27/11/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import SwiftUI

struct GroupURL {
    
    #if os(OSX)
    static var current = "5AMFX8X5ZN.howlongleft"
    #elseif os(watchOS)
    static var current = "group.com.ryankontos.How-Long-Left"
    #else
    static var current = "group.com.ryankontos.How-Long-Left"
    #endif
    
}

class HLLDefaults {

    static var shared = HLLDefaults()
    
    static var defaults = UserDefaults.init(suiteName: "group.com.ryankontos.How-Long-Left")!
    
   /* #if targetEnvironment(macCatalyst)
    static var defaults = UserDefaults.init(suiteName: "5AMFX8X5ZN.howlongleft")!
    #elseif os(OSX)
    static var defaults = UserDefaults.init(suiteName: GroupURL.current)!
    #elseif os(watchOS)
    static var defaults = UserDefaults.standard
    #else
    static var defaults = UserDefaults(suiteName: GroupURL.current)!
    #endif */
    
   
    
    struct appData {
        
        
        static var launchedVersion: String? {
            
            get {
                
                
                return defaults.string(forKey: "launchedVersion")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "launchedVersion")
                
            }
            
            
        }
        
        static var newestLaunchedVersion: String? {
            
            get {
                
                
                return defaults.string(forKey: "newestLaunchedVersion")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "newestLaunchedVersion")
                
            }
            
            
        }
        
        static var proUser: Bool {
            
            
            get {
                
                return defaults.bool(forKey: "pro")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "pro")
                
            }
            
            
            
            
        }
        
        static var migratedCoreData: Bool {
            
            
            get {
                
                return defaults.bool(forKey: "migratedCoreData")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "migratedCoreData")
                
            }
            
            
            
            
        }
        
    }
    
    struct widget {
        
        static var latestTimeline: HLLTimeline? {
            
            get {
               
                guard let data = defaults.data(forKey: "WidgetLatestTimeline") else { return nil }
                
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode(HLLTimeline.self, from: data)
                return decoded
                
            }
            
            set {
                
                let encoder = JSONEncoder()
                let encoded = try! encoder.encode(newValue)
                
                print("Set widget timeline")
                
                defaults.set(encoded, forKey: "WidgetLatestTimeline")
                
                
            }
            
        }
        
        static var theme: WidgetTheme {
            
            
            get {
                
                let value = defaults.integer(forKey: "WidgetTheme")
                return WidgetTheme(rawValue: value)!
                
            }
            
            set(to) {
                
                defaults.set(to.rawValue, forKey: "WidgetTheme")
                
                
            }
            
            
        }
        
        static var showProgressBar: Bool {
            
            
            get {
                
                return !defaults.bool(forKey: "widgetHideBar")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "widgetHideBar")
                
            }
            
            
            
        }
        
        static var showSelected: Bool {
            
            
            get {
                
                return !defaults.bool(forKey: "widgetIgnoreSelected")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "widgetIgnoreSelected")
                
            }
            
            
            
        }
        
        static var tintCalendarColour: Bool {
            
            
            get {
                
                return !defaults.bool(forKey: "widgetUseDefaultCol")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "widgetUseDefaultCol")
                
            }
            
            
        }
        
     
        
    }
    
    
    struct rename {
        
        static var promptToRename: Bool {
            
            
            get {
                
                return !defaults.bool(forKey: "RNDontPrompt")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "RNDontPrompt")
                
            }
            
            
            
            
        }
        
        static var renameInTheBackground: Bool {
            
            
            get {
                
                return defaults.bool(forKey: "RNInBackground")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "RNInBackground")
                
            }
            
            
            
            
        }
        
        static var lastRenameDate: Date? {
            
            get {
                
                if let date = defaults.object(forKey: "lastRenameDate") as? Date {
                    
                    return date
                    
                }
                
                return nil
                
            }
            
            set(to)  {
                
                defaults.set(to, forKey: "lastRenameDate")
                
            }
            
        }
        
        
    }
    
    struct complication {
        
        static var latestTimeline: HLLTimeline? {
            
            get {
               
                guard let data = defaults.data(forKey: "ComplicationLatestTimeline") else { return nil }
                
                let decoder = JSONDecoder()
                let decoded = try? decoder.decode(HLLTimeline.self, from: data)
                return decoded
                
            }
            
            set {
                
                let encoder = JSONEncoder()
                let encoded = try! encoder.encode(newValue)
                
                defaults.set(encoded, forKey: "ComplicationLatestTimeline")
            }
            
        }
        
        static var largeCountdown: Bool {
            
                
                get {
                    
                    return defaults.bool(forKey: "largeCountdown")
                    
                }
                
                set (to) {
                    
                    defaults.set(to, forKey: "largeCountdown")
                    
                }
                
            
            
            
        }
        
        static var complicationEnabled: Bool {
            
                
                get {
                    
                    return !defaults.bool(forKey: "complicationDisabled")
                    
                }
                
                set (to) {
                    
                    defaults.set(!to, forKey: "complicationDisabled")
                    
                }
                
            
            
            
        }
        
        static var complicationPurchased: Bool {
            
                
                get {
                    
                 
                    
                    return defaults.bool(forKey: "ComplicationPurchased")
                    
                }
                
                set (to) {
                    
                    defaults.set(to, forKey: "ComplicationPurchased")
                    
                }
                
            
            
            
        }

        static var overrideComplicationPurchased: Bool {
            
                
                get {
                    
                    return defaults.bool(forKey: "overrideComplicationPurchased")
                    
                }
                
                set (to) {
                    
                    defaults.set(to, forKey: "overrideComplicationPurchased")
                    
                }
            
        }
        
        static var overridenComplicationPurchasedStatus: Bool {
            
                
                get {
                    
                    return defaults.bool(forKey: "overridenComplicationPurchasedStatus")
                    
                }
                
                set (to) {
                    
                    defaults.set(to, forKey: "overridenComplicationPurchasedStatus")
                    
                }
            
        }
        
        static var unitLabels: Bool {
            
                
                get {
                    
                    return defaults.bool(forKey: "ComplicationUnitLabels")
                    
                }
                
                set (to) {
                    
                    defaults.set(to, forKey: "ComplicationUnitLabels")
                    
                }
            
        }
        
        static var showSeconds: Bool {
            
                
                get {
                    
                    return defaults.bool(forKey: "ComplicationShowSeconds")
                    
                }
                
                set (to) {
                    
                    defaults.set(to, forKey: "ComplicationShowSeconds")
                    
                }
            
        }
        
        static var tintComplication: Bool {
            
                
                get {
                    
                    return !defaults.bool(forKey: "ComplicationNoTint")
                    
                }
                
                set (to) {
                    
                    defaults.set(!to, forKey: "ComplicationNoTint")
                    
                }
            
        }
        
        
    }
    
    struct general {
        
        static var selectedEventID: String? {
            
            get {
                
                return HLLDefaults.defaults.string(forKey: "SelectedEvent")
                
                
            }
            
            set (to) {
                
                HLLDefaults.defaults.set(to, forKey: "SelectedEvent")
                
            }
            
            
        }
        
        static var pinnedEventIdentifiers: [String] {
            
            get {
                
                return HLLDefaults.defaults.stringArray(forKey: "PinnedEventIdentifiers") ?? [String]()
                
                
            }
            
            set (to) {
                
                HLLDefaults.defaults.set(to, forKey: "PinnedEventIdentifiers")
                
            }
            
            
        }
        
        static var hiddenEvents: [String:String] {
             
             get {
                 
                 return HLLDefaults.defaults.object(forKey: "hiddenEventIDS") as? [String : String] ?? [String:String]()
                 
                 
             }
             
             set (to) {
                 
                 HLLDefaults.defaults.set(to, forKey: "hiddenEventIDS")
                 
             }
             
             
         }
        
        static var eventInfoOrdering: [[HLLEventInfoItemType]] {
                   
                   get {
                       
                       var returnDict = [[HLLEventInfoItemType]]()
                       
                       if let test = HLLDefaults.defaults.object(forKey: "InfoItemOrdering") as? [[String]] {
                           
                           for item in test {
                               
                               var array = [HLLEventInfoItemType]()
                               
                               for subItem in item {
                                   
                                   if let type = HLLEventInfoItemType(rawValue: subItem) {
                                       
                                       array.append(type)
                                       
                                   }
                                   
                               }
                               
                               returnDict.append(array)
                               
                           }
                           
                       }
                    
                    return returnDict
                       
                   }
                   
                   set (to) {
                       
                    var final = [[String]]()
                    
                    for item in to {
                        
                        var array = [String]()
                        
                        for subItem in item {
                            
                            array.append(subItem.rawValue)
                            
                        }
                        
                        final.append(array)
                    
                    }
                    
                       defaults.set(final, forKey: "InfoItemOrdering")
                       
                   }
                   
               }
        
        static var use24HourTime: Bool {
            
            get {
                
                return defaults.bool(forKey: "use24HrTime")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "use24HrTime")
                
            }
            
        }
        
        static var showAllDay: Bool {
            
            get {
                
                return defaults.bool(forKey: "showAllDay")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "showAllDay")
                
            }
            
        }
        
        static var askToHide: Bool {
            
            get {
                
                return !defaults.bool(forKey: "HideEventHidingAlert")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "HideEventHidingAlert")
                
            }
            
        }

        
        static var showAllDayAsCurrent: Bool {
            
            get {
                
                return defaults.bool(forKey: "showAllDayAsCurrent")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "showAllDayAsCurrent")
                
            }
            
        }
        

        static var showAllDayInStatusItem: Bool {
            
            get {
                
                return defaults.bool(forKey: "showAllDayInCurrent")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "showAllDayInCurrent")
                
            }
            
        }
        
        static var showUpcomingWeekMenu: Bool {
            
            get {
                
                return !defaults.bool(forKey: "hideUpcomingSubmenu")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "hideUpcomingSubmenu")
                
            }
            
        }
        

        
        static var showNextOccurItems: Bool {
            
            get {
                
                return !defaults.bool(forKey: "hideNextOccur")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "hideNextOccur")
                
            }
            
        }
        
        
        static var useNextOccurList: Bool {
                 
                 get {
                     
                     return !defaults.bool(forKey: "nextOccurSubmenus")
                     
                 }
                 
                 set (to) {
                     
                     defaults.set(!to, forKey: "nextOccurSubmenus")
                     
                 }
                 
             }
        
        static var showPercentage: Bool {
            
            get {
                
                return !defaults.bool(forKey: "hidePercentage")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "hidePercentage")
                
            }
            
        }
        
        static var showLocation: Bool {
            
            get {
                
                return !defaults.bool(forKey: "hideLocation")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "hideLocation")
                
            }
            
        }
        
        
        
        static var combineDoubles: Bool {
            
            get {
                
                return defaults.bool(forKey: "combineDoubleEvents")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "combineDoubleEvents")
                
            }
            
        }
        
        static var showUpdates: Bool {
            
            get {
                
                return !defaults.bool(forKey: "hideUpdates")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "hideUpdates")
                
            }
            
        }
        
        
    }
    
    struct watch {
        
        static var largeCell: Bool {
            
            get {
                
                return defaults.bool(forKey: "WatchFirstEventLarge")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "WatchFirstEventLarge")
                
            }
            
        }
        
        
        static var complicationEnabled: Bool {
            
            get {
                
                return !defaults.bool(forKey: "WatchComplicationDisabled")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "WatchComplicationDisabled")
                
            }
            
        }
        
        
        static var showUpcoming: Bool {
                   
                   get {
                       
                       return !defaults.bool(forKey: "hideUpcomingWatch")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(!to, forKey: "hideUpcomingWatch")
                       
                   }
                   
        }
        
        static var upcomingMode: WatchUpcomingEventsDisplayMode {
            
            get {
                
                return WatchUpcomingEventsDisplayMode(rawValue: defaults.integer(forKey: "WatchUpcomingMode"))!
                
            }
            
            set {
                
                defaults.set(newValue.rawValue, forKey: "WatchUpcomingMode")
                
            }
            
        }
        
        static var listOrderMode: WatchEventListOrderMode {
            
            get {
                
                return WatchEventListOrderMode(rawValue: defaults.integer(forKey: "WatchListOrderMode"))!
                
            }
            
            set {
                
                defaults.set(newValue.rawValue, forKey: "WatchListOrderMode")
                
            }
            
        }
        
        static var showCurrent: Bool {
                   
            get {
                return !defaults.bool(forKey: "WatchHideCurrent")
            }
                   
            set (to) {
                defaults.set(!to, forKey: "WatchHideCurrent")
            }
                   
        }
        
        static var showCurrentFirst: Bool {
                   
                   get {
                       
                       return defaults.bool(forKey: "showCurrentFirst")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(to, forKey: "showCurrentFirst")
                       
                   }
                   
        }
        
        static var lastScheduledUpdateDate: Date? {
            
            get {
                
                return defaults.object(forKey: "WatchLastScheduledUpdateDate") as? Date
                
               
            }
            
            set {
               
                defaults.set(newValue, forKey: "WatchLastScheduledUpdateDate")
                
                
                
            }
            
        }
        
        static var showOneEvent: Bool {
                   
                   get {
                       
                       return defaults.bool(forKey: "dontshowListWatch")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(to, forKey: "dontshowListWatch")
                       
                   }
                   
        }
        
        static var showSeconds: Bool {
                   
                   get {
                       
                       return !defaults.bool(forKey: "WatchHideSeconds")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(!to, forKey: "WatchHideSeconds")
                       
                   }
                   
        }
        
        
        static var showSecondsWristDown: Bool {
                   
                   get {
                       
                       return !defaults.bool(forKey: "WatchHideSecondsAlwaysOn")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(!to, forKey: "WatchHideSecondsAlwaysOn")
                       
                   }
                   
        }
        
        
        static var syncPreferences: Bool {
                   
                   get {
                       
                       return !defaults.bool(forKey: "syncPreferences")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(!to, forKey: "syncPreferences")
                       
                   }
                   
        }
        
        static var largeHeaderLocation: Bool {
                   
                   get {
                       
                       return !defaults.bool(forKey: "largeHeaderLocation")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(!to, forKey: "largeHeaderLocation")
                       
                   }
                   
        }
        
    }
    
    struct menu {
        
        static var topLevelUpcoming: Bool {
            
            get {
                
                return !defaults.bool(forKey: "topLevelUpcoming")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "topLevelUpcoming")
                
            }
            
        }
        
        static var listUpcoming: Bool {
            
            get {
                
                return !defaults.bool(forKey: "hideUpcoming")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "hideUpcoming")
                
            }
            
        }
        
       
        
    }
    
    struct statusItem {
        
        static var disabled: Bool {
            
            get {
                
               return defaults.bool(forKey: "statusItemDisabled")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "statusItemDisabled")
                
            }
            
        }
        
        static var mode: StatusItemMode {
            
            get {
                
                if let mode = StatusItemMode(rawValue: defaults.integer(forKey: "statusItemTimerMode")) {
                    
        
                    
                  //  print("MakeMode: \(int) \(mode)")
                    
                    return mode
                    
                } else {
                    
                    return StatusItemMode.Timer
                    
                }
                
            }
            
            set (to) {
                
                if to != .Off {
                    defaults.set(to.rawValue, forKey: "RecentStatusItemTimerMode")
                }
                
                defaults.set(to.rawValue, forKey: "statusItemTimerMode")
                
            }
            
        }
        
        static var mostRecentEnabledMode: StatusItemMode {
            
            get {
                
                if let mode = StatusItemMode(rawValue: defaults.integer(forKey: "RecentStatusItemTimerMode")) {
                            
                            return mode
                            
                        } else {
                            
                            return StatusItemMode.Timer
                            
                        }
                
                
            }
            
        }
        
        static var appIconStatusItem: Bool {
            
            get {
                
                return defaults.bool(forKey: "appIconStatusItem")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "appIconStatusItem")
                
            }
            
            
            
        }
        
        static var showCurrent: Bool {
            
            get {
                
                return !defaults.bool(forKey: "hideCurrentSI")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "hideCurrentSI")
                
            }
            
        }
        
        static var showUpcoming: Bool {
            
            get {
                
                return !defaults.bool(forKey: "hideUpcomingSI")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "hideUpcomingSI")
                
            }
            
        }
        
        static var eventMode: StatusItemEventMode {
            
            get {
                
                let value = HLLDefaults.defaults.integer(forKey: "StatusItemEventMode")
                return StatusItemEventMode(rawValue: value)!
                  
                
            }
            
            set (to) {
                
                HLLDefaults.defaults.set(to.rawValue, forKey: "StatusItemEventMode")
                
            }
            
            
        }
        
        static var migratedEventMode: Bool {
            
            get {
                
                HLLDefaults.defaults.string(forKey: "migratedEventMode") != nil
                
            }
            
        }
        
        static var showEndTime: Bool {
            
            get {
                
                return defaults.bool(forKey: "showStatusItemEndTime")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "showStatusItemEndTime")
                
            }
            
        }
        
        static var showPercentage: Bool {
            
            get {
                
                return defaults.bool(forKey: "showStatusItemPercentage")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "showStatusItemPercentage")
                
            }
            
        }
        
        static var hideEventsOn: Date? {
            
            get {
                
                var returnValue: Date?
                
                if let ref = defaults.object(forKey: "HideEventsDate") as? Double {
                    returnValue = Date(timeIntervalSinceReferenceDate: ref)
                }
                
                return returnValue
                
            }
            
            set(to) {
                
                if let date = to {
                
                defaults.set(date.startOfDay().timeIntervalSinceReferenceDate, forKey: "HideEventsDate")
                
                } else {
                    
                    defaults.set(nil, forKey: "HideEventsDate")
                    
                }
            }
            
            
        }
        
        static var inactive: Bool {
            
            get {
                
                return hideEventsOn != nil
                
            }
            
            
        }
        
        static var showTitle: Bool {
            
            get {
                
                return !defaults.bool(forKey: "hideStatusItemTitle")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "hideStatusItemTitle")
                
            }
            
        }
        
        static var limitStatusItemTitle: Bool {
                   
                   get {
                       
                       return !defaults.bool(forKey: "dontLimitStatusItemTitle")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(!to, forKey: "dontLimitStatusItemTitle")
                       
                   }
                   
        }
        
        static var statusItemTitleLimit: Int {
                   
                   get {
                       
                    if let number = defaults.object(forKey: "SILimit") as? Int {
                       return number
            } else {
            
                defaults.set(25, forKey: "SILimit")
                return HLLDefaults.statusItem.statusItemTitleLimit
            
            }
                   
            
            }
                   
                set (to) {
                       
                    if to > 4 {
                    
                       defaults.set(to, forKey: "SILimit")
                        
                    } else {
                        print("No!!!")
                        defaults.set(5, forKey: "SILimit")
                    }
                       
                }
                   
        }
        
        static var showLeftText: Bool {
            
            get {
                
                return defaults.bool(forKey: "showLeftText")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "showLeftText")
                
            }
            
        }
        
        static var doneAlerts: Bool {
            
            get {
                
                return !defaults.bool(forKey: "noDoneAlerts")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "noDoneAlerts")
                
            }
            
        }

        static var useFullUnits: Bool {
            
            get {
                
                
                return defaults.bool(forKey: "useFullUnits")
                
            }
            
            set (to) {
                print("UFU SET")
                defaults.set(to, forKey: "useFullUnits")
                
            }
            
        }

        
        static var hideTimerSeconds: Bool {
            
            get {
                
                return defaults.bool(forKey: "hideTimerSecs")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "hideTimerSecs")
                
            }
            
        }

        
        
    }
    
    struct calendar {
        
        
        static var selectedCalendar: String? {
            
            get {
                
                return defaults.string(forKey: "selectedCalendar")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "selectedCalendar")
                
            }
            
        }
        
        static var enabledCalendars: [String] {
            
            get {
                
                return defaults.stringArray(forKey: "setCalendars") ?? [String]()
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "setCalendars")
                
            }
            
        }
        
        static var disabledCalendars: [String] {
            
            get {
                
                return defaults.stringArray(forKey: "disabledCalendars") ?? [String]()
                
            }
            
            set (to) {
                
                
                
                defaults.set(to, forKey: "disabledCalendars")
                
            }
            
        }
        
        
        static var useAllCalendars: Bool {
            
            get {
                
                return !defaults.bool(forKey: "doNotUseAllCalendars")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "doNotUseAllCalendars")
                
            }
            
        }
        
        static var useNewCalendars: Bool {
            
            get {
                
                return !defaults.bool(forKey: "doNotUseNewCalendars")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "doNotUseNewCalendars")
                
            }
            
        }
        
    }
    
    struct notifications {
        
        
        static var enabled: Bool {
            
            get {
                
                return !defaults.bool(forKey: "muteNotificationsMac")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "muteNotificationsMac")
                
            }
            
            
        }
        
        static var enablediOS: Bool {
            
            get {
                
                return defaults.bool(forKey: "muteNotifications")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "muteNotifications")
                
            }
            
            
        }
        
        static var startNotifications: Bool {
            
            get {
                
                return !defaults.bool(forKey: "doNotDoStartNotos")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "doNotDoStartNotos")
                
            }
            
            
        }
        
        static var endNotifications: Bool {
            
            get {
                
                return !defaults.bool(forKey: "doNotDoEndNotos")
                
            }
            
            set (to) {
                
                defaults.set(!to, forKey: "doNotDoEndNotos")
                
            }
            
            
        }
        
        static var sounds: Bool {
            
            get {
                
                return defaults.bool(forKey: "useSounds")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "useSounds")
                
            }
            
            
        }
        
        static var soundName: String? {
            
            get {
                
                if HLLDefaults.notifications.sounds == true {
                    
                    return "Hero"
                    
                } else {
                    
                    return nil
                    
                }
                
                
                
            }
            
            
        }
        
        static var hotkey: HLLHotKeyOption {
            
            get {
                
                if let hotKey = HLLHotKeyOption(rawValue: defaults.integer(forKey: "hotKey")) {
                    
                    return hotKey
                    
                } else {
                    
                    return HLLHotKeyOption.OptionW
                    
                }
                
            }
            
            set (to) {
                
                defaults.set(to.rawValue, forKey: "hotKey")
                
            }
            
        }
        
        static var doneNotificationOnboarding: Bool {
            
            get {
                
                return HLLDefaults.defaults.bool(forKey: "DoneNotificationOnboarding")
                
            }
            
            set (to) {
                
                HLLDefaults.defaults.set(to, forKey: "DoneNotificationOnboarding")
                
            }
        }
        
        static var presentedNotificationOnboarding: Bool {
                   
            get {
                       
                return HLLDefaults.defaults.bool(forKey: "PresentedNotificationOnboarding")
                       
            }
                   
            set (to) {
                       
                HLLDefaults.defaults.set(to, forKey: "PresentedNotificationOnboarding")
                       
            }
            
        }
        
        static var defaultMilestones = [600, 300, 60]
        static var defaultPercentageMilestones = [25, 50, 75]

        
        static var milestones: [Int] {
            
            get {
                
                var returnArray = [Int]()
                
                if defaults.stringArray(forKey: "Milestones") == nil {
                   defaults.set(defaultMilestones.map { String($0) }, forKey: "Milestones")
                }
                
                if let hkArray = defaults.stringArray(forKey: "Milestones") {
                    
                    for item in hkArray {
                        
                        if let intItem = Int(item) {
                            
                            returnArray.append(intItem)
                            
                        }
                        
                    }
                    
                    
                    
                    
                    
                }
                
                
                return returnArray
                
            }
            
            set (to) {
                
              //  print("Setting Milestones to  \(to)")
                
                var setArray = [String]()
                
                for item in to {
                    
                    setArray.append(String(item))
                    
                }
                
                
                
                defaults.set(setArray, forKey: "Milestones")
                
            }
            
            
        }
        
        static var startsInMilestones: [Int] {
            
            get {
                
                var returnArray = [Int]()
                
                if let hkArray = defaults.stringArray(forKey: "startsInMilestones") {
                    
                    for item in hkArray {
                        
                        if let intItem = Int(item) {
                            
                            returnArray.append(intItem)
                            
                        }
                        
                    }
                    
                    
                    return returnArray
                    
                    
                } else {
                    defaults.set([], forKey: "startsInMilestones")
                    return []
                    
                }
                
            }
            
            set (to) {
                
              //  print("Setting Milestones to  \(to)")
                
                var setArray = [String]()
                
                for item in to {
                    
                    setArray.append(String(item))
                    
                }
                
                
                
                defaults.set(setArray, forKey: "startsInMilestones")
                
            }
            
            
        }
        
        static var Percentagemilestones: [Int] {
            
            get {
                
                var returnArray = [Int]()
                
                if let hkArray = defaults.stringArray(forKey: "PercentageMilestones") {
                    
                    for item in hkArray {
                        
                        if let intItem = Int(item) {
                            
                            returnArray.append(intItem)
                            
                        }
                        
                    }
                    
                    return returnArray
                    
                    
                } else {
                    defaults.set(["25", "50", "75"], forKey: "PercentageMilestones")
                    return [25, 50, 75]
                    
                }
                
                
            }
            
            set (to) {
                
                var setArray = [String]()
                
                for item in to {
                    
                    setArray.append(String(item))
                    
                }
                
                defaults.set(setArray, forKey: "PercentageMilestones")
                
            }
            
            
        }
  
    }
     
    
    
    struct currentEventView {
      
        static var showPercentageLabels: Bool {
            
            get {
                
                return defaults.bool(forKey: "showPercentageLabelsInCurrentEventView")
                
            }
            
            set (to) {
                
                defaults.set(to, forKey: "showPercentageLabelsInCurrentEventView")
                
            }
            
        }
        
        
    }
    
    struct appExtensions {
        
        static var showUpcoming: Bool {
                   
                   get {
                       
                       return !defaults.bool(forKey: "hideUpcomingInExtensions")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(!to, forKey: "hideUpcomingInExtensions")
                       
                   }
                   
               }
        
        
    }
    
    struct countdownsTab {
        
        static var showInProgress: Bool {
                   
                   get {
                       
                       return !defaults.bool(forKey: "hideCurrentInCountdownsTab")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(!to, forKey: "hideCurrentInCountdownsTab")
                       
                   }
                   
            }
        
        static var cardAppearance: CountdownCardAppearance {
            
            get {
                
                let stored = defaults.integer(forKey: "CountdownCardAppearance")
                return CountdownCardAppearance(rawValue: stored)!
                
            }
            
            set {
                
                defaults.set(newValue.rawValue, forKey: "CountdownCardAppearance")
                
            }
            
        }
        
        static var showSeconds: Bool {
                   
                   get {
                       
                       return !defaults.bool(forKey: "hideSecondsInCountdownTab")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(!to, forKey: "hideSecondsInCountdownTab")
                       
                   }
                   
            }
        
        static var onlyEndingToday: Bool {
                   
                   get {
                       
                       return defaults.bool(forKey: "onlyShowCurrentEndingToday")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(to, forKey: "onlyShowCurrentEndingToday")
                       
                   }
                   
            }
        
        
        static var showUpcoming: Bool {
                   
                   get {
                       
                       return !defaults.bool(forKey: "hideUpcomingInCountdownsTab")
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(!to, forKey: "hideUpcomingInCountdownsTab")
                       
                   }
                   
            }
        
        
        static var upcomingCount: Int {
                   
                   get {
                       
                       let value =  defaults.integer(forKey: "UpcomingInCountdownsCount")
                       if value < 1 { return 1 }
                       return value
                       
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(to, forKey: "UpcomingInCountdownsCount")
                       
                   }
                   
               }
        
        
        
        static var sectionOrder: [CountdownTabSection] {
                   
                   get {
                       
                       if let array =  defaults.stringArray(forKey: "CountdownTabSectionOrder") {
                           return array.map({ return CountdownTabSection(rawValue: $0)! })
                       }
                       
                       return [.pinned, .inProgress, .upcoming]
                       
                   }
                   
                   set (to) {
                       
                       defaults.set(to.map({$0.rawValue}), forKey: "CountdownTabSectionOrder")
                       
                   }
                   
               }
        
        
    }
    
    struct premiumPurchases {
        
        static var complication: Bool {
            
            get {
                
                return HLLDefaults.defaults.bool(forKey: "PremiumPurchases.Complication")
                
            }
            
            set {
                
                HLLDefaults.defaults.set(newValue, forKey: "PremiumPurchases.Complication")
                
            }
            
        }
        
        static var widget: Bool {
            
            get {
                
                return HLLDefaults.defaults.bool(forKey: "PremiumPurchases.Widget")
                
            }
            
            set {
                
                HLLDefaults.defaults.set(newValue, forKey: "PremiumPurchases.Widget")
                
            }
            
        }
        
        
    }
    
    
}

enum CountdownTabSection: String {
    
    case pinned = "Pinned"
    case inProgress = "In Progress"
    case upcoming = "Upcoming"
    
}

protocol DefaultsTransferHandler {
    
    func transferDefaultsDictionary(_ defaultsToTransfer: [String:Any])
    
}

protocol DefaultsTransferObserver {
    
    func defaultsUpdated()
    
}

enum HLLDefaultsKeys: CaseIterable {
    
    enum General: String, CaseIterable {
        
        case test = "test"
        case example = "lol"
        
    }
    
    enum Calendars: String, CaseIterable {
        
        case enabledCalendars = "set"
        case disabledCalendars = "disabled"
        
    }
    
}

enum OldRoomNamesSetting: Int {
    
    case doNotShow = 2
    case showInSubmenu = 0
    case replace = 1
    
}

enum WidgetTheme: Int, CaseIterable, Identifiable {
    
    case system = 0
    case light = 1
    case dark = 2
    
    var id: WidgetTheme { return self }
    
    var name: String {
        
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
        
    }
    
}

enum CountdownCardAppearance: Int, CaseIterable {
    
    case gradient = 0
    case transparent = 1
    case flat = 2
    case plain = 3
    
    func getName() -> String {
        
        switch self {
        case .gradient:
            return "Gradient"
        case .transparent:
            return "Transparent"
        case .flat:
            return "Flat"
        case .plain:
            return "Plain"
        }
        
    }
    
}

enum WatchUpcomingEventsDisplayMode: Int, CaseIterable {
    
    case withDetail = 0
    case withCountdown = 1
    case off = 2
    
    
    var displayName: String {
        
        switch self {
        case .withDetail:
            return "With Detail"
        case .withCountdown:
            return "With Countdown"
        case .off:
            return "Off"
        }
        
    }
    
    
}

enum WatchEventListOrderMode: Int, CaseIterable {
    
    case chronological = 2
    case currentFirst = 0
    case upcomingFirst = 1
    
    var displayName: String {
        
        switch self {
            
        case .chronological:
            return "Chronological"
        case .currentFirst:
            return "In Progress First"
        case .upcomingFirst:
            return "Upcoming First"
        }
        
    }
    
}
