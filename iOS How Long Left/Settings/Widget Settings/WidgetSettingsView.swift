//
//  WidgetSettingsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 16/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct WidgetSettingsView: View {
    
    @ObservedObject var model = Model()
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        List {
            
           
            
            Section("Widget Appearance") {
                    
                Picker(selection: $model.manualAppearance, content: {
                    
                    ForEach(WidgetTheme.allCases, content: { item in
                        Text(item.name)
                    })
                    
                }, label: { EmptyView() })
                .pickerStyle(.inline)
                
            }
            
            
            
         /*   Section(content: {
                
                NavigationLink(destination: {
                    
                    WidgetConfigListView().environmentObject(WidgetConfigurationStore())
                    
                }, label: {
                    
                    Text("Widget Configurations")
                    
                })
                
            },header: { Text("Advanced") } , footer: { Text("Use widget configurations to define rules for how your widgets should choose which event to display at a given time.") }) */
           
            
        }
        .listStyle(.insetGrouped)
       // .navigationTitle("Widget")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    class Model: ObservableObject {
        
        var tintCountdown: Bool = false
        
       
        var manualAppearance: WidgetTheme = HLLDefaults.widget.theme {
            
            willSet {
                
                HLLDefaults.widget.theme = newValue
                objectWillChange.send()
                
                WidgetUpdateHandler.shared.updateWidget(force: true, background: false)
                
            }
            
        }
        
    }
    
}

struct WidgetSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetSettingsView()
    }
}



