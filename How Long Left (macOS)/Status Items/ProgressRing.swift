//
//  ProgressRing.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 26/11/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

@available(OSX 10.15.0, *)
struct ProgressRing: View {
    var body: some View {
        
        ZStack {
                    Circle()
                        .stroke(lineWidth: 3)
                        .opacity(0.3)
                        .foregroundColor(Color(NSColor.highlightColor))
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(0.022, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color(NSColor.highlightColor))
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear)

                }
        
    }
}

@available(OSX 10.15, *)
struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing()
    }
}
