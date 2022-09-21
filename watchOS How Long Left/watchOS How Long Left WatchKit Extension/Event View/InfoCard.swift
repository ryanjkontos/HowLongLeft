//
//  InfoCard.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 5/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct InfoCard: View {
    
    @State var title: String
    @State var info: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 1) {
            
            Text(title)
                .textCase(.uppercase)
                .foregroundColor(.secondary)
                .font(.system(size: 13, weight: .light, design: .default))
            
            Text(info)
                .font(.system(size: 15, weight: .regular, design: .default))
            
            
        }
        .padding(.bottom, 12)
        
    }
}

struct InfoCard_Previews: PreviewProvider {
    static var previews: some View {
        InfoCard(title: "Title", info: "Info")
    }
}
