//
//  EnabledCalendarsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EnabledCalendarsView: View {
    
    @EnvironmentObject var calendarsManager: EnabledCalendarsManager
    
    var body: some View {
        
        List {
            
            Section(header: Text("Enabled Calendars"), footer: Text("Events from enabled calendars will appear in the app")) {
            
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
                    
                    
                }, set: { value in
                    
                    
                    HLLDefaults.calendar.useNewCalendars = value
                    
                }), label: {Text("Use New Calendars")})
                
            }
            
        }
        .onAppear(perform: {
            
            calendarsManager.update()
            
        })
       
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Calendars")
        .toolbar(content: {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    
                    withAnimation {
                        calendarsManager.toggleAll()
                    }
                    
                    
                    
                }, label: {Text(calendarsManager.allEnabled ? "Deselect All" : "Select All").transition(.opacity)
                    .animation(.none, value: calendarsManager.allEnabled)})
                    
            }
            
        })
        
        
    }
}

struct EnabledCalendarsView_Previews: PreviewProvider {
    static var previews: some View {
        EnabledCalendarsView()
    }
}


