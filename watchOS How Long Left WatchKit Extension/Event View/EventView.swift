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
    
    @State var selection: Int = 1
        
    @Binding var open: HLLEvent?
    
    @Environment(\.scenePhase) private var scenePhase
    
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    var body: some View {
        
        Group {
        
        if openOnOptions {
            EventOptionsView(event: event)
        } else {
            TabView(selection: $selection) {
                EventOptionsView(event: event)
                    .tag(0)
                
                EventInfoView(event: event)
                    .tag(1)
                EventTimerView(event: event)
                    .tag(2)
            }
            .onAppear(perform: {
                
                if openOnOptions {
                    selection = 0
                } else {
                    selection = 1
                }
                
            })
            
        }
            
        
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
