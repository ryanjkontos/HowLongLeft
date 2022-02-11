//
//  ContentView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 4/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct ContentView: View {

    @ObservedObject var orientationInfo = OrientationInfo()
    @ObservedObject var selectionController = SelectedTabManager()
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var eventViewEvent: HLLEvent?
    @State var showOnboarding = false
    @State var blur = false
    
    @ObservedObject var store = Store()
    
    @State var appearanceSetting = AppAppearance.auto
    
    @ViewBuilder var body: some View {
        
    
            
            TabBarContentView(eventViewEvent: $eventViewEvent)
                .environmentObject(store)
            
     
        
        .sheet(item: $eventViewEvent, onDismiss: { eventViewEvent = nil }, content: { event in
            
            EventView(event: event)
            
        })
       .sheet(isPresented: $showOnboarding, content: {
            
            NavigationView {
                WelcomeView()
                    .environmentObject(store)
            }
           
            .environment(\.colorScheme, getColorScheme())
            
        })
        .environment(\.colorScheme, getColorScheme())
        .environmentObject(selectionController)
        .accentColor(.orange)
        .edgesIgnoringSafeArea(.all)
        
          
       
    }
    
    
    func getColorScheme() -> ColorScheme {
        
        switch appearanceSetting {
        case .auto:
            return colorScheme
        case .light:
            return .light
        case .dark:
            return .dark
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum AppAppearance: String, CaseIterable {
    
    case auto = "Automatic"
    case light = "Light"
    case dark = "Dark"
    
}
