//
//  WidgetUpdateHandler.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 17/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import WidgetKit

class WidgetUpdateHandler: EventSourceUpdateObserver {
    
    
    let widgetStateFetcher = WidgetStateFetcher()
    
    static var shared: WidgetUpdateHandler = WidgetUpdateHandler()
    
     var timelineGen = HLLTimelineGenerator(type: .widget)
    
    //let configStore = WidgetConfigurationStore()
    
    var configDict = [String: Int]()
 
    static let queue = DebouncingQueue(label: "WidgetUpdateQueue")
    
    init() {
        
        HLLEventSource.shared.addeventsObserver(self, immediatelyNotify: true)
        updateWidget()
        updateConfigDict()
        
        
    }
    
    func updateWidget(force: Bool = false, background: Bool = false) {

        WidgetUpdateHandler.queue.sync { [unowned self] in
            
            
            
            if force {
                triggerWidgetUpdate()
                return
                
            }
            
            // print("Checking widget update!")
   

                let newGen  = HLLTimelineGenerator(type: timelineGen.timelineType)
                
                
                timelineGen = newGen
                if timelineGen.shouldUpdate() == .needsReloading {
                    
                     print("Reloading Widgets...")
                    
                    triggerWidgetUpdate()
                    
                    if background {
                        let count = HLLDefaults.defaults.integer(forKey: "BGCausedWidgetUpdateCount")+1
                        HLLDefaults.defaults.set(count, forKey: "BGCausedWidgetUpdateCount")
                    }
                    
                } else {
                    print("Not Reloading Widgets...")
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
        
        if #available(macOS 11, *) {
           /* WidgetCenter.shared.getCurrentConfigurations({ (result) in
                
                switch result {
                    
                case .success(let info):
                    
                    for item in info {
                        
                        // print(item)
                        
                        if let config = item.id.configuration as? HLLWidgetConfigurationIntent, let widgetConfig = config.config, let id = widgetConfig.identifier {
                            
                            // print("Kind: \(item.kind)")
                            
                            if let value = dict[id] {
                                dict[id] = value + 1
                            } else {
                                dict[id] = 1
                            }
                            
                        }
                        
                    }
                    
                    completion(dict)
                    
                case .failure(let error):
                    break
                    // print(error.localizedDescription)
                    
                }
            }) */
        }
        
    }
    
    func eventsUpdated() {
        
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 3) {
            self.updateWidget()
        }
        
       
        
    }
    
}
