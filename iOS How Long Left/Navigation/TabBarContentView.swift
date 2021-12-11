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
    
    
    var body: some View {
        
        TabView {
            
            CountdownsParentView(eventViewEvent: $eventViewEvent)
                .tabItem({
                    
                    Image(systemName: HLLAppTab.inProgress.imageName())
                    Text(HLLAppTab.inProgress.tabName())
                    
                })
            
            UpcomingEventListParentView(eventViewEvent: $eventViewEvent)
                .tabItem({
                    
                    Image(systemName: HLLAppTab.upcoming.imageName())
                    Text(HLLAppTab.upcoming.tabName())
                    
                })
            
            SettingsView()
                .tabItem({
                    
                    Image(systemName: HLLAppTab.settings.imageName())
                    Text(HLLAppTab.settings.tabName())
                    
                })
                
            
        }
        .introspectTabBarController(customize: { controller in
            
            
            let appearance = controller.tabBar.standardAppearance
            appearance.configureWithDefaultBackground()
            controller.tabBar.scrollEdgeAppearance = appearance
            
        })
        .accentColor(.orange)
        
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
