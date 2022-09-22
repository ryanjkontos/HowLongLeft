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
                
                
                getListLabel(rowName: "Countdowns", foreground: .white , background: .orange, image: "hourglass", size: 13)
                
                
            })
            
            
       
     
 
            
            NavigationLink(destination: { EventsSettingsView() }, label: {
                
                getListLabel(rowName: "Events", foreground: .white , background: .orange, image: "calendar.day.timeline.trailing", size: 10.5)
                
            })
            
            NavigationLink(destination: { EnabledCalendarsView()
                    .environmentObject(AppEnabledCalendarsManager.shared)
            }, label: {
                
                
                getListLabel(rowName: "Calendars", foreground: .white , background: .orange, image: "calendar", size: 12)
                
            })
            
                
            
            Section {
                
                NavigationLink(destination: { NicknamesListView() }, label: {
                    
                    getListLabel(rowName: "Nicknames", foreground: .white , background: .orange, image: "character.cursor.ibeam", size: 10.5)
                    
                })
                
                NavigationLink(destination: { HiddenEventsSettingsView() }, label: {
                    
                    getListLabel(rowName: "Hidden Events", foreground: .white , background: .orange, image: "eye.slash.fill", size: 10.5)
                    
                })
                
            }


            Section {
                
                NavigationLink(destination: { ComplicationParentView()
                        .environmentObject(store)

                }, label: {
                    
                    getListLabel(rowName: "Complication", foreground: .orange , background: .white, image: "watchface.applewatch.case", size: 13)
                    
                })
                
            }
            
            
         
            
            Section {
                
                NavigationLink(destination: { LoggerView()

                }, label: {
                    
                    getListLabel(rowName: "Debug Log", foreground: .white ,background: .purple, image: "ant.fill", size: 11)
                    
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
    
    func getListLabel(rowName: String, foreground: Color, background: Color, image: String, size: CGFloat) -> some View {
        
        HStack(spacing: 6) {
           
            Circle()
                .frame(width: 20)
                .foregroundColor(background)
                .overlay {
                    Image(systemName: image)
                        .font(.system(size: size))
                        .foregroundColor(foreground)
                        
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
