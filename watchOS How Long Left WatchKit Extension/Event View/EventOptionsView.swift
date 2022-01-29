//
//  EventOptionsView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 5/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventOptionsView: View {
    
    init(event: HLLEvent) {
        dataObject = .init(event)
    }
    
    @ObservedObject var dataObject: EventOptionsViewObject
    
    var body: some View {
       
        List {
            
            Button(action: { dataObject.isPinned.toggle() }, label: {
                Text("\(dataObject.isPinned ? "Unpin" : "Pin")")
            })
            
            Button(action: {}, label: {
                Text("Hide")
            })
            
            Button(action: {}, label: {
                Text("Nickname")
            })
            
            
            
        }
        .navigationTitle("Options")
        
    }
}

class EventOptionsViewObject: ObservableObject {
    
    init(_ event: HLLEvent) {
        self.event = event
    }
    
    var event: HLLEvent
    
    var isPinned: Bool {
        
        get {
            
            return event.isSelected
            
        }
        
        set {
            
            SelectedEventManager.shared.setSelection(newValue, for: event)
            self.objectWillChange.send()
        }
        
    }
    
}

struct EventOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        EventOptionsView(event: .previewEvent())
    }
}
