//
//  LiveEventInfo.swift
//  How Long Left
//
//  Created by Ryan Kontos on 17/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

class LiveEventInfo: ObservableObject {
    
    
    @Published var items = [HLLEventInfoItem]()
    @Published var statusString: String!
    
    var configuration: [HLLEventInfoItemType]
    var event: HLLEvent {
        
        didSet {
            gen = HLLEventInfoItemGenerator(event)
        }
        
    }
    
    private var gen: HLLEventInfoItemGenerator!
    private var timer: Timer!
    
    init(event: HLLEvent, configuration: [HLLEventInfoItemType] = HLLEventInfoItemType.allCases) {
        
        
        self.event = event
        self.configuration = configuration
        
        gen = HLLEventInfoItemGenerator(event)
        
    
        
       
    }
    

    func getInfoItems(at date: Date = Date()) -> [HLLEventInfoItem] {
        
        gen.getInfoItems(for: configuration, at: date)
    }
    
    
}
