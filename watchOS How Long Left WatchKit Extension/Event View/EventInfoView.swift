//
//  EventInfoView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 5/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import MapKit

struct EventInfoView: View {
    
    @State var event: HLLEvent
    
    var body: some View {
        
        ScrollView {
            HStack {
                
                VStack(alignment: .leading) {
                
                    HStack(spacing: 6) {
                    
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .foregroundColor(Color(event.color))
                            .frame(width: 4)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(event.title)")
                                .font(.system(size: 17, weight: .medium, design: .default))
                            Text("\(event.startDate.formattedTime()) - \(event.endDate.formattedTime())")
                                .foregroundColor(.secondary)
                                .font(.system(size: 15, weight: .regular, design: .default))
                        }
                        
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                
                   
                
                    
                }
                
                
                Spacer()
                
            }
            
            
            
            
            
            
            
        }
        .navigationTitle("Info")
        .padding(.horizontal, 10)
        
        
    }
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
            NavigationView {
                EventInfoView(event: .previewEvent())
            }
        
    }
}
