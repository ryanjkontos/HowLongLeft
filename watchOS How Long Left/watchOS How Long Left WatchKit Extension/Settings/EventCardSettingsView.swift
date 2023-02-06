//
//  EventCardSettingsView.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 1/1/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventCardSettingsView: View {
    var body: some View {
        
        Form {
            
          
            
            Section(content: {
                
                Toggle(isOn: .constant(true), label: {
                    Text("Location")
                })
                
                Toggle(isOn: .constant(true), label: {
                    Text("Countdown")
                })
                
                Toggle(isOn: .constant(true), label: {
                    Text("Percent Complete")
                })
                
                Toggle(isOn: .constant(true), label: {
                    Text("Start and End")
                })
               
                
            }, header: {
                Text("Info Text")
            }, footer: {
                Text("If multiple options are selected, they will be cycled through at 2 second intervals.")
            })
            
        }
        
    }
}

struct EventCardSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        EventCardSettingsView()
    }
}
