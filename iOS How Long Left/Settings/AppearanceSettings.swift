//
//  AppearanceSettings.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 26/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct AppearanceSettings: View {
    
    @Binding var appAppearance: AppAppearance
    
    var body: some View {
        
        List {
        
        Picker(selection: $appAppearance, content: {
            
            ForEach(AppAppearance.allCases, id: \.self, content: {
                
                Text($0.rawValue)
                    .id($0)
                
            })
            
        }, label: {
            
            Text("Appearance")
            
        })
                .pickerStyle(.inline)
        }
        
        
    }
}

struct AppearanceSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceSettings(appAppearance: .constant(.auto))
    }
}
