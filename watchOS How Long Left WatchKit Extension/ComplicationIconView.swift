//
//  ComplicationIconView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 20/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ComplicationIconView: View {
    
    @Environment(\.complicationRenderingMode) var renderingMode
    
    var isInGauge: Bool
    var isInXL: Bool
    var invertedForeground: Bool
    
    var fullColorTint: UIColor?
    
    let fullColorGradient = Gradient(colors: [Color("HLLGradient1"), Color("HLLGradient2")])
   
    var image: some View {
        
        Image(systemName: "clock")
            
            .resizable()
            .renderingMode(.template)
            .font(.system(size: 60, weight: .bold, design: .default))
            .padding(.all, calculatePadding())
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        
            
        
    }

    
    var body: some View {
        
        ZStack {
            
            Group {
            
            if renderingMode == .fullColor {
                Color("ComplicationBackgroundColor")
                    
            } else {
                Color.white.opacity(0.1)
                    
            }
                
            }
            .if(isInXL) {
                
                $0.complicationForeground()
            }
            
            if renderingMode == .fullColor {
                
                Group {
                
                if let tint = fullColorTint {
                    Color(tint)
                } else {
                    LinearGradient(gradient: fullColorGradient, startPoint: .top, endPoint: .bottom)
                }
                    
                }
                
                    .mask({
                        
                        image
                        
                    })
                    .if(!isInXL) {
                        
                        $0.complicationForeground()
                    }
                    
                
            } else {
                
                image
                    .if(!isInXL) {
                        
                        $0.complicationForeground()
                    }
                    
                    .foregroundColor(.orange)
                
            }
    
            
        }
        
        
    
    }
    
    func calculatePadding() -> CGFloat {
        
        var padding: CGFloat = 10
        
        if isInXL {
            padding = 25
        }
        
        if isInGauge {
            padding = padding/2
        }
        
        return padding
        
    }
    
   
}

struct ComplicationIconView_Previews: PreviewProvider {
    static var previews: some View {
        ComplicationIconView(isInGauge: false, isInXL: false, invertedForeground: false)
            .previewLayout(.fixed(width: 85, height: 85))
    }
}


extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
