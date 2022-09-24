//
//  UpcomingSubCard.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 20/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct UpcomingSubCard: View {
    
    @State var event: HLLEvent
    
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 12, style: .circular)
            .background(content: {Color(uiColor: .systemBackground)})
            .foregroundColor(Color(uiColor: event.color).opacity(0.2))
            
            .overlay {
                
                HStack(spacing: 10) {
                    
                    Rectangle()
                        .foregroundColor(Color(uiColor: event.color))
                        .opacity(0.4)
                        .frame(width: 9)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        
                        Text("\(event.title)")
                            .foregroundColor(Color(uiColor: UIColor.label))
                            .font(.system(size: 16, weight: .medium, design: .default))
                            
                        Text("\(event.startDate.formattedTime()) - \(event.endDate.formattedTime())")
                            .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
                            .font(.system(size: 13, weight: .regular, design: .default))
                    }
                    Spacer()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .circular))
            .clipped()
            .drawingGroup()
            
    }
}

struct UpcomingSubCard_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingSubCard(event: .previewEvent())
            .previewLayout(.fixed(width: 275, height: 55))
    }
}
