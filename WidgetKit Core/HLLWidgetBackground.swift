//
//  HLLWidgetBackground.swift
//  How Long Left
//
//  Created by Ryan Kontos on 27/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import SwiftUI


struct HLLWidgetBackground: ViewModifier {
    
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
    
    func body(content: Content) -> some View {
        
        ZStack {
        
            if colorScheme == .light {
            
            Color.white
                
            } else {
                
                Color(#colorLiteral(red: 0.07201712472, green: 0.07201712472, blue: 0.07201712472, alpha: 1))
                
            }
            
          //  LinearGradient(gradient: .init(colors: [.white, Color(#colorLiteral(red: 0.8872886464, green: 0.8872886464, blue: 0.8872886464, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            content
            
        }
    }
}
