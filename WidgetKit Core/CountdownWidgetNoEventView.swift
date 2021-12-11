//
//  CountdownWidgetNoEventView.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 17/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WidgetKit


struct CountdownWidgetNoEventView: View {
    
    @Environment(\.colorScheme) var systemColorScheme: ColorScheme
    
    var colorScheme: ColorScheme {
        
        if HLLDefaults.widget.theme == .system {
            return systemColorScheme
        }
        
        if HLLDefaults.widget.theme == .dark {
            return .dark
        }
        
        return .light
    }
    
    var body: some View {
            
            VStack {
            
                Spacer()
                
                HStack {
                
            Text("No Events")
                .font(Font.system(size: 25, weight: .bold, design: .default))
                .foregroundColor(col)
                .multilineTextAlignment(.leading)
                .padding(.vertical, 25)
                
 
                    Spacer()
                    
                }
                
            }
            .colorScheme(colorScheme)
            
            
        
        
    }
    
    var col: Color {
        
        if colorScheme == .dark {
            return .white
        } else {
            return .HLLOrange
        }
        
    }
    
}

struct CountdownWidgetNoEventView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownWidgetNoEventView()
            .modifier(HLLWidgetBackground())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
