//
//  StatusItemView.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 13/10/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct StatusItemView: View, EventSourceUpdateObserver {
    func eventsUpdated() {
       
    }
    

    init() {
        HLLEventSource.shared.addeventsObserver(self)
    }
    
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    let textGen = HLLStatusItemContentGenerator(configuration: .defaultConfiguration())
    
    @State var text = "HLL"
    
    func getDate() -> Date {
        return Calendar.current.date(bySetting: .nanosecond, value: 0, of: Date().addingTimeInterval(-1))!
    }
    

    
    var body: some View {
        

        HStack(spacing: 7) {
                
                Text(text)
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .monospacedDigit()
                
             
                    
                    ProgressView(value: 0.25)
                    .controlSize(.small)
                        .progressViewStyle(.circular)
                       // .frame(width: 5,height: 5)
                    
                
                
            }
                
         
            .onReceive(timer, perform: { _ in
                textGen.updateEvent()
                text = textGen.getStatusItemContent().text ?? "HLL"
               // // print(text)
            })
        
    }
    
  
}

struct StatusItemView_Previews: PreviewProvider {
    static var previews: some View {
        StatusItemView()
    }
}
