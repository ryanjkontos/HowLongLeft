//
//  TabBarContentView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 4/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct TabBarContentView: View {

    
    @Binding var eventViewEvent: HLLEvent?
    
    @State var selection = 0
    
    @State var launchEvent: HLLEvent?
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            CountdownsParentView(eventViewEvent: $eventViewEvent, launchEvent: $launchEvent)
                .tabItem({
                    
                    Image(systemName: HLLAppTab.inProgress.imageName())
                    Text(HLLAppTab.inProgress.tabName())
                    
                })
                .tag(0)
            
            UpcomingEventListParentView(eventViewEvent: $eventViewEvent)
                .tabItem({
                    
                    Image(systemName: HLLAppTab.upcoming.imageName())
                    Text(HLLAppTab.upcoming.tabName())
                    
                })
                .tag(1)
            
            NavigationView {
                SettingsView()
                    .navigationTitle("Settings")
            }
                
                .tabItem({
                    
                    Image(systemName: HLLAppTab.settings.imageName())
                    Text(HLLAppTab.settings.tabName())
                    
                })
                .tag(2)
                
            
        }
        .introspectTabBarController(customize: { controller in
            
            
            let appearance = controller.tabBar.standardAppearance
            appearance.configureWithDefaultBackground()
            controller.tabBar.scrollEdgeAppearance = appearance
            
        })
        .accentColor(.orange)
        
    }
    

    func handleLaunchEvent() {
        
        guard let event = launchEvent else { return }
        
        if event.completionStatus == .current {
            selection = 0
        } else {
            selection = 1
        }
        
    }
    
}

struct TabBarContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarContentView(eventViewEvent: .constant(nil))
    }
}

extension String {
    
    func print() {
        
        Swift.print(self)
        
    }
    
}
