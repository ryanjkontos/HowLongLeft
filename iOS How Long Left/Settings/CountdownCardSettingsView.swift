//
//  CountdownCardSettingsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 5/12/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CountdownCardSettingsView: View {
    
    @ObservedObject var settingsObject = CountdownCardSettingsObject()
    
    
    
    var body: some View {
       
        List {
            
            Section(content: {
                
                Toggle("Show Seconds", isOn: $settingsObject.showSeconds)
                
            }, header: { Text("Timers") })
            
            Picker(selection: $settingsObject.cardBackground, content: {
                
                ForEach(CountdownCardAppearance.allCases, id: \.self, content: {
                    
                    Text($0.getName())
                        .id($0)
                    
                })
                
            }, label: {
                
                Text("Card Background")
                
            })
            .pickerStyle(.inline)
            
        }
      
        
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Countdown Cards")
        
    }
}

struct CountdownCardSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownCardSettingsView()
            .environmentObject(CountdownCardSettingsObject())
    }
}
