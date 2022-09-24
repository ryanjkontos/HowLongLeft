//
//  IconCell.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 24/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct IconCell: View {
    
    @State var label: String
    @State var iconImageName: String
    @State var iconBackground: Color
    @State var iconFill: Color
    
    var body: some View {
       
        HStack(spacing: 12) {
            
            RoundedIcon(iconBackground: iconBackground, iconFill: iconFill, cornerRadius: 6, iconImageName: iconImageName, fontSize: 17)
                .frame(width: 28, height: 28)
            Text(label)
                .foregroundColor(Color(UIColor.label))
            
            Spacer()
        }
        .padding(.leading, -3)
        
    }
}

struct IconCell_Previews: PreviewProvider {
    static var previews: some View {
        IconCell(label: "General", iconImageName: "gear", iconBackground: .white, iconFill: .orange)
    }
}
