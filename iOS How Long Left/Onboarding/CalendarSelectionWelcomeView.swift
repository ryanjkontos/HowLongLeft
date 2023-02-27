//
//  CalendarSelectionWelcomeView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 16/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CalendarSelectionWelcomeView: View {
    
    @ObservedObject var calendarsManager: EnabledCalendarsManager
    
    var body: some View {
        VStack {
            
            VStack(spacing: 18) {
                
                HStack {
                    
                    Spacer()
                    
                    Text("Choose Your Calendars")
                        .font(.system(size: 35, weight: .bold, design: .default))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                 
                    Spacer()
                    
                }
                
            }
            .padding(.vertical, 20)
            .padding(.bottom, 15)
            .padding(.top, 15)
            .disabled(true)
            
            List {
                
                Section(content: {
                   
              
                    
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
                    
                })
                
                
            }
            
           
            
            .navigationBarHidden(true)
            .listStyle(.plain)
            .safeAreaInset(edge: .bottom, content: {
                
                VStack(spacing: 21) {
                    
                   
                    NavigationLink(destination: { WelcomeRoutingView(source: .welcome) }, label: {
                        
                        Text("Next")
                            .font(.headline)
                            .frame(maxWidth: 300)
                        
                    })
                        .tint(.orange)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .padding(.horizontal, 20)
                        .frame(height: 52, alignment: .center)
                        .navigationBarHidden(true)
                        .padding(.bottom, 20)
                    
                }
                .padding(.top, 10)
                .frame(maxWidth: .infinity)
                .background {
                    Color(uiColor: UIColor.systemBackground).edgesIgnoringSafeArea(.all)
                }
                
              
                
            })
     
            
        }
        
    }
}

struct CalendarSelectionWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarSelectionWelcomeView(calendarsManager: AppEnabledCalendarsManager.shared)
    }
}
