//
//  EventLimitEditor.swift
//  How Long Left
//
//  Created by Ryan Kontos on 18/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventLimitEditor: View {
    
    
    
    @ObservedObject var object: Model
    
    init(type: EventLimitType) {
        object = Model(type: type)
    }
    
    var body: some View {
       
        Form {
            
            Section(content: {
                Stepper("\(object.value)", value: $object.value, in: 1...99)
            }, header: {
                Text("\(getName()) Events Limit")
            }, footer: {
                if object.value == 0 {
                    Text("\(getName()) Events will not be limited in the main event list.")
                } else {
                    Text("Only up to \(object.value) \(getName().lowercased()) event\(object.value == 1 ? "" : "s") will be shown in the main event list. If there are more, a \"view more\" button will appear.")
                }
                
                
            })
            
        }
        
    }
    
    func getName() -> String {
        
        switch object.type {
            
        case .current:
            return "In-progress"
        case .upcoming:
            return "Upcoming"
        }
        
    }
    
    class Model: ObservableObject {
        
        var type: EventLimitType
        
        init(type: EventLimitType) {
            
            self.type = type
            
            switch type {
                
            case .current:
                value = HLLDefaults.watch.currentLimit
            case .upcoming:
                value = HLLDefaults.watch.upcomingLimit
            }
        }
        
        @Published var value: Int {
            didSet {
                
                switch type {
                    
                case .current:
                    // print("Setting current limit")
                    HLLDefaults.watch.currentLimit = value
                case .upcoming:
                    // print("Setting upcoming limit")
                    HLLDefaults.watch.upcomingLimit = value
                }
                
            }
        }
        
    }
    
}

struct EventLimitEditor_Previews: PreviewProvider {
    static var previews: some View {
        EventLimitEditor(type: .current)
    }
}

enum EventLimitType {
    case current
    case upcoming
}
