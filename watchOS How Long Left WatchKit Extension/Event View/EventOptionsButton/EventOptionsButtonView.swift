//
//  EventOptionsButtonView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 22/6/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventOptionsButtonView: View {
    
    var label: String
    var symbol: String
    var color: Color
    var action: (() -> Void)
    
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(color.opacity(0.25))
                .aspectRatio(CGSize(width: 41, height: 25), contentMode: .fill)
               
                .overlay(content: {
                    
                    Image(systemName: symbol)
                        .font(.system(size: 27, weight: .semibold, design: .default))
                        .foregroundColor(color)
                    
                })
            
            
            Text(label)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .font(.system(size: 14, weight: .regular, design: .default))
            
        }
    }
}

struct EventOptionsButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EventOptionsButtonView(label: "End", symbol: "xmark", color: .red) {
            
        }
    }
}
