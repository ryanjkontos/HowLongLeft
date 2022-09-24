//
//  RoundedIcon.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 24/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct RoundedIcon: View {
    
    @State var iconBackground: Color
    @State var iconFill: Color
    @State var cornerRadius: CGFloat
    @State var iconImageName: String
    @State var fontSize: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            
            .foregroundColor(iconBackground)
            .overlay {
                Image(systemName: iconImageName)
                    .font(.system(size: fontSize))
                    .foregroundColor(iconFill)
            }
            .drawingGroup()
    }
}
