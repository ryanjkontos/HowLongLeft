//
//  WidgetUpdateHandler.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 17/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

class WidgetUpdateHandler: EventPoolUpdateObserver {
    
    
    let widgetStateFetcher = WidgetStateFetcher()
    
    static var shared: WidgetUpdateHandler = WidgetUpdateHandler()
    
    let timelineGen = HLLTimelineGenerator(type: .widget)
    
    let configStore = WidgetConfigurationStore()
    
    var configDict = [String: Int]()
 
    init() {
        
        HLLEventSource.shared.addEventPoolObserver(self, immediatelyNotify: true)
        updateWidget()
        updateConfigDict()
        
        
    }
    
    func updateWidget(force: Bool = false, background: Bool = false) {

        
        
        if force { triggerWidgetUpdate(); return }
        
        print("Checking widget update!")
   
        configStore.loadGroups()
        let enabledConfigs = configDict.keys.compactMap({ key in configStore.allGroups.first(where: { $0.id == key })  })
        
        for config in enabledConfigs {
            
            timelineGen.timelineConfiguration = config
            if timelineGen.shouldUpdate() == .needsReloading {
        
            print("Reloading Widgets...")
                
                triggerWidgetUpdate()
                
                if background {
                    let count = HLLDefaults.defaults.integer(forKey: "BGCausedWidgetUpdateCount")+1
                    HLLDefaults.defaults.set(count, forKey: "BGCausedWidgetUpdateCount")
                }
                
            } else {
                print("Not updating widget")
            }
            
        }
        
    }
    
    private func triggerWidgetUpdate() {
        
        #if os(macOS)


        if #available(macOS 11, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }

        #else

            WidgetCenter.shared.reloadAllTimelines()

        #endif

        
    }
    
 
    func updateConfigDict() {
        
        getWidgetConfigDict(completion: { configDict in
            self.configDict = configDict
            
        })
        
    }
    
    func getWidgetConfigDict(completion: @escaping  ( ([String:Int]) -> Void  ) ) {
        
        var dict = [String: Int]()
        
        WidgetCenter.shared.getCurrentConfigurations({ (result) in
            
            switch result {
                
            case .success(let info):
                    
                for item in info {
                    
                    print(item)
                    
                    if let config = item.id.configuration as? HLLWidgetConfigurationIntent, let widgetConfig = config.config, let id = widgetConfig.identifier {
                        
                        print("Kind: \(item.kind)")
                        
                        if let value = dict[id] {
                            dict[id] = value + 1
                        } else {
                            dict[id] = 1
                        }
                        
                    }
                    
                }
                
                completion(dict)
                
                case .failure(let error):
                    print(error.localizedDescription)
                
            }
        })
        
    }
    
    func eventPoolUpdated() {
        updateWidget()
        
    }
    
}
