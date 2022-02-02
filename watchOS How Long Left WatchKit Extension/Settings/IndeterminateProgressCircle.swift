//
//  IndeterminateProgressCircle.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 2/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct IndeterminateProgressCircle: View {
    
    @State private var isAnimating = false
    var foreverAnimation: Animation {
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        }
    
    var body: some View {
        
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(lineWidth: 2)
            .frame(width: 27)
            .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            .foregroundColor(.gray)
            .onAppear { withAnimation{ self.isAnimating = true } }
            
    }
}

struct IndeterminateProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        IndeterminateProgressCircle()
    }
}
