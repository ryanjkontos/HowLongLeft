//
//  EnabledCalendarsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EnabledCalendarsView: View {
    
    @ObservedObject var calendarsManager: EnabledCalendarsManager
    
    var contextWord: String
    
    var body: some View {
        
        List {
            
            #if os(watchOS)
    
                Section {
                    toggleAllButton
                        .listItemTint(.orange.opacity(0.4))
                        
                }

            #endif
            
            Section(header: Text("Enabled Calendars"), footer: Text("Events from enabled calendars will appear in the \(contextWord)")) {
            
            ForEach($calendarsManager.allCalendars) { $calendar in
                
                Toggle(isOn: $calendar.enabled, label: {
                    HStack {
                        Circle()
                                .frame(width: 11, height: 11, alignment: .center)
                                .foregroundColor(Color(cgColor: calendar.calendar.cgColor))
                        Text(calendar.calendar.title)
                                .padding(.leading, 5)
                        Spacer()
                    }
                })
                    
                
            }
                
            }
            
            Section(footer: Text("Enable new calendars automatically")) {
                
                Toggle(isOn: Binding(get: {
                    
                    return HLLDefaults.calendar.useNewCalendars
                    
                }, set: {
                    HLLDefaults.calendar.useNewCalendars = $0
                    
                    
                }), label: {Text("Use New Calendars")})
                
            }
            
        }
        .onAppear(perform: {
            
            calendarsManager.update()
            
        })
       
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Calendars")
        .toolbar(content: {
            
            #if os(iOS)
            
            ToolbarItem(placement: .automatic) {
                
                 toggleAllButton
            }
            
            #endif
            
        })
        
        
    }
    
    var toggleAllButton: some View {
        
        Button(action: {
            
            withAnimation {
                calendarsManager.toggleAll()
            }
            
        }, label: {
            
            Group {
            
            #if os(watchOS)
            
            HStack {
                Spacer()
                toggleAllText
                Spacer()
            }
            
            
            #else
            
                toggleAllText
            
            #endif
                
            }
            
            .transition(.opacity)
            .animation(.none, value: calendarsManager.allEnabled)})
        
    }
    
    var toggleAllText: some View {
        Text(calendarsManager.allEnabled ? "Disable All" : "Enable All")
    }
    
    
}

struct EnabledCalendarsView_Previews: PreviewProvider {
    static var previews: some View {
        EnabledCalendarsView(calendarsManager: AppEnabledCalendarsManager.shared, contextWord: "app")

    }
}


