//
//  CircleXButtonView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CircleXButtonView: View {
    var body: some View {
        
        Circle()
            .overlay {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.gray)
            }
            .hoverEffect(.lift)
            .foregroundColor(Color(UIColor.secondarySystemFill))
            .frame(width: 29, height: 29, alignment: .center)
        
    }
}

struct CircleXButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleXButtonView()
    }
}
