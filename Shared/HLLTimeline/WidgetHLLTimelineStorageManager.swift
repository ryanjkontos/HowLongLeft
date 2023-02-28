//
//  WidgetHLLTimelineStorageManager.swift
//  How Long Left
//
//  Created by Ryan Kontos on 18/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

class WidgetHLLTimelineStorageManager {
    
    private let defaultsKey = "WidgetTimelines"
    
    func saveTimeline(_ timeline: HLLTimeline, configID: String? = nil) {
        
        guard let id = configID else { HLLDefaults.widget.latestTimeline = timeline.getArchive(); return }
        let data = try! JSONEncoder().encode(timeline)
        var dict = [String:Data]()
        if let savedDict = HLLDefaults.defaults.dictionary(forKey: defaultsKey) as? [String:Data] { dict = savedDict }
        dict[id] = data
        HLLDefaults.defaults.set(dict, forKey: defaultsKey)
        
    }
    
    func getTimeline(withID configID: String?) -> HLLTimeline.Archive? {
        
        guard let id = configID else { return HLLDefaults.widget.latestTimeline }
        guard let savedDict = HLLDefaults.defaults.dictionary(forKey: defaultsKey) as? [String:Data] else { return nil }
        guard let data = savedDict[id] else { return nil }
        return try? JSONDecoder().decode(HLLTimeline.Archive.self, from: data)
        
    }
    
}
