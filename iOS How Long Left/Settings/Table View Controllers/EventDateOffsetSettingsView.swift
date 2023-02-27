//
//  EventDateOffsetSettingsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 24/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventDateOffsetSettingsView: View {
    
    @ObservedObject var store = CalendarTimeOffsetStore()
    
    var body: some View {
        Form {
            
            Section {
                
                Toggle(isOn: .constant(true)) {
                    Text("Enable Event Time Offsets")
                }
                
            }
            
            Section {
                
                ForEach($store.objects) { $object in
                    
                    
                    Stepper(value: $object.offset, label: {
                        
                        HStack {
                            
                            HStack {
                                Circle()
                                    .foregroundColor(Color(uiColor: UIColor(cgColor: object.calendar.cgColor)))
                                    .frame(width: 10, height: 10)
                                Text("\(object.calendar.title)")
                            }
                            
                            Spacer()
                            Text(getLabelText(object.offset))
                                .foregroundColor(.secondary)
                        }
                        .padding(.trailing, 10)
                        
                    })
                    
                }
         
                
            }
            
            
        }
    }
    
    func getLabelText(_ val: TimeInterval) -> String {
        
        if val >= 0 {
            return "+\(Int(val)) sec"
        } else {
            return "\(Int(val)) sec"
        }
        
    }
    
}

struct EventDateOffsetSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        EventDateOffsetSettingsView()
    }
}
