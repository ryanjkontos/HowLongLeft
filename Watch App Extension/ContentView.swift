//
//  ContentView.swift
//  WatchOS SwiftUI Extension
//
//  Created by Ryan Kontos on 27/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    
    
    var deviceWidth: CGFloat = WKInterfaceDevice.current().screenBounds.size.width
    
    var body: some View {
        
        MainView()
        .edgesIgnoringSafeArea(.horizontal)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
        
        ContentView()
            .previewDisplayName("44mm")
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 44mm"))
            
       /* ContentView()
            .previewDisplayName("40mm")
            .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 6 - 40mm"))
            
            ContentView()
                .previewDisplayName("38mm")
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 3 - 38mm"))
                
            ContentView()
                .previewDisplayName("42mm")
                .previewDevice(PreviewDevice(rawValue: "Apple Watch Series 3 - 42mm"))
            
            */
            
            
        }
    }
}
