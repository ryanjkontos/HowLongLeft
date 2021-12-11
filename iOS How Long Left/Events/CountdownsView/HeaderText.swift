//
//  HeaderText.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct HeaderText: View {
    
    @State var value: String
    
    var body: some View {
        Text(value)
            .font(.system(size: 14, weight: .medium, design: .default))
            .foregroundColor(Color(UIColor.systemGray))
            .textCase(.uppercase)
        
    }
}

struct HeaderText_Previews: PreviewProvider {
    static var previews: some View {
        HeaderText(value: "Text")
    }
}
