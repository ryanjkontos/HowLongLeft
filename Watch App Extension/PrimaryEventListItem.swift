//
//  PrimaryEventListItem.swift
//  Watch App Extension
//
//  Created by Ryan Kontos on 24/10/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct PrimaryEventListItem: View {
    
    @State var showBar = true
    
    @State var event: HLLEvent
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 13) {
            
            
            VStack(alignment: .leading, spacing: 2) {
                
                Text("\(event.title)")
                    .foregroundColor(.white)
                    .font(Font.system(size: 26, weight: .semibold, design: .default))
                    .minimumScaleFactor(0.001)
                Text("\(event.countdownTypeString) in")
                    .foregroundColor(Color(.lightGray))
                    .font(Font.system(size: 16, weight: .semibold, design: .default))
                
                
                
            }
            // .background(Color.green)
            
            Spacer()
            
            VStack(spacing: 8) {
                
                HStack {
                    
                    Countdown(event: event)
                        .font(Font.system(size: 30, weight: .semibold, design: .default).monospacedDigit())
                        .foregroundColor(Color(event.uiColor))
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                    
                    Spacer()
                    
                }
                
                
                
                
                if showBar {
                    
                    Capsule()
                        .foregroundColor(Color.gray.opacity(0.5))
                        .frame(height: 7.5, alignment: .center
                               
                        )
                        .padding(.horizontal, 1.25)
                        .overlay(
                            
                            GeometryReader { proxy in
                                
                                Capsule()
                                    .foregroundColor(Color(event.uiColor))
                                    .frame(width: CGFloat(Double(proxy.size.width)/(100/75)), height: proxy.size.height)
                                    .shadow(radius: 3)
                                
                            }
                            
                            
                        )
                    
                }
                
            }
            
        }

        
    }
}

struct PrimaryEventListItem_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryEventListItem(event: .previewEvent())
    }
}
