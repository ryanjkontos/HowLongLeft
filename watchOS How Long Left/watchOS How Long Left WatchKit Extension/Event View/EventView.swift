//
//  EventView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 3/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventView: View {
  
    
    var event: HLLEvent
    
    var openOnOptions: Bool
    
    @State var selection: Int = 0
        
    @Binding var open: HLLEvent?
    
    @Environment(\.scenePhase) private var scenePhase
    
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    
    
    var passPresentingBinding: Binding<Bool> {
        Binding(get: {
            
            return true
            
        }, set: { _ in
            
            open = nil
            
        })
    }
    
    var body: some View {
        

            TabView(selection: $selection) {
                
                EventInfoView(event: event, presenting: passPresentingBinding, scrollToOptions: openOnOptions)
                    .tag(0)
                EventTimerView(event: event)
                    .tag(1)
            }

            
            .toolbar(content: {
            
            ToolbarItem(placement: .cancellationAction, content: {
                
                Button(action: {
                    
                    open = nil
                    
                }, label: {
                    
                    Text("Close")
                    
                })
                
            })
            
        })

    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: .previewEvent(), openOnOptions: false, open: .constant(nil))
    }
}
