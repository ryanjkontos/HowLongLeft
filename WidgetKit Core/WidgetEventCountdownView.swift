//
//  WidgetEventCountdownView.swift
//  iOSWidgetExtension
//
//  Created by Ryan Kontos on 17/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WidgetKit


struct WidgetEventCountdownView: View {
    var body: some View {
        
        HStack(spacing: 5) {
        
            
         /*   RoundedRectangle(cornerRadius: 5, style: .circular)
        .foregroundColor(.orange)
        .frame(width: 3, height: 50)
                
            */
            
            
        VStack(alignment: .leading, spacing: -2) {
    
        
    Text("Event ends in")
        .font(.system(size: 15, weight: .semibold, design: .default))
    Text("00:00")
        .font(.system(size: 25, weight: .medium, design: .default))
        .foregroundColor(.orange)
                
        
        
        }
        
        
            
            Spacer()
        
    }

        
        
    }
    
}

struct WidgetEventCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEventCountdownView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
    }
}
