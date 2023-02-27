//
//  CalendarAccessLoadingView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 16/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CalendarAccessLoadingView: View {
    
    @State private var next = false
    
    var body: some View {
        VStack {
            
            VStack(spacing: 6) {
                
                Text("Calendar Access")
                    .font(.system(size: 35, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                   
                
                Text("How Long Left needs to access your calendar.")
                    //.foregroundColor(.secondary)
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
                
            }
            .padding(.top, 40)
            
            Spacer()
            
            ProgressView()
                .progressViewStyle(.circular)
                .controlSize(.large)
            Spacer()
            
            NavigationLink("", isActive: $next) {
                Text("Worked!")
            }
            .hidden()
            
            
        }
        .navigationBarHidden(true)
        .onAppear() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Task {
                   let result = await CalendarReader.shared.getCalendarAccess()
                    next = result
                }
                
            }
            
           
        }
    }
}

struct CalendarAccessLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true), content: {
                CalendarAccessLoadingView()
                    .interactiveDismissDisabled(true)
            })
            
        
    }
}
