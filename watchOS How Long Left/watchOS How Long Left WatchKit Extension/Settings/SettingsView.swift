//
//  SettingsView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 5/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var store: Store
    
    @Binding var open: Bool
    
    var body: some View {
        
        Form {

            NavigationLink(destination: { CountdownSettingsView() }, label: {
                
                
                getListLabel(rowName: "Countdowns", background: .blue, image: "hourglass", size: 13)
                
                
            })
            
            
            NavigationLink(destination: { EnabledCalendarsView()
                    .environmentObject(AppEnabledCalendarsManager.shared)
            }, label: {
                
                
                getListLabel(rowName: "Calendars", background: .red, image: "calendar", size: 12)
                
            })
            
     
 
            
            NavigationLink(destination: { EventsSettingsView() }, label: {
                
                getListLabel(rowName: "Events", background: .orange, image: "calendar.day.timeline.trailing", size: 10.5)
                
            })
                


            
            NavigationLink(destination: { ComplicationParentView()
                    .environmentObject(store)

            }, label: {
                
                getListLabel(rowName: "Complication", background: .green, image: "watchface.applewatch.case", size: 13)
                
            })
                
      
            
            Section {
                
                NavigationLink(destination: { LoggerView()

                }, label: {
                    
                    getListLabel(rowName: "Debug Log", background: .purple, image: "ant.fill", size: 11)
                    
                })
                
            }
            
            
            
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Settings")
        .toolbar(content: {
            
            ToolbarItem(placement: .cancellationAction, content: {
                
                Button(action: {
                    
                    open = false
                    
                }, label: {
                    
                    Text("Close")
                    
                })
                
            })
            
            
        })
        
    }
    
    func getListLabel(rowName: String, background: Color, image: String, size: CGFloat) -> some View {
        
        HStack(spacing: 6) {
           
            Circle()
                .frame(width: 20)
                .foregroundColor(background)
                .overlay {
                    Image(systemName: image)
                        .font(.system(size: size))
                
                        
                }
            
            Text(rowName)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Spacer()
            
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(open: .constant(true))
            .environmentObject(Store())
    }
}