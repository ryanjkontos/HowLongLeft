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
           
            
            Section {
                
                NavigationLink(destination: {
                    
                    WidgetConfigListView().environmentObject(WidgetConfigurationStore())
                    
                }, label: {
                    
                    Text("Configurations")
                    
                })
                
            }
            
            
            Section("Appearance") {
                    
                Picker(selection: $model.manualAppearance, content: {
                    
                    ForEach(WidgetTheme.allCases, content: { item in
                        Text(item.name)
                    })
                    
                }, label: { EmptyView() })
                .pickerStyle(.inline)
                
            }
           
            
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Widget")
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



