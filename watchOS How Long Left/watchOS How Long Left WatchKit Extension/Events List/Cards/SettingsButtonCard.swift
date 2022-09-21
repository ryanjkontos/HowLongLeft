//
//  SettingsButtonCard.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 30/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct SettingsButtonCard: View {
    var body: some View {
        
        
            
            HStack {
                Spacer()
                Text("Settings")
                    .foregroundColor(.black)
                Spacer()
            }
      
        
    }
}

struct SettingsButtonCard_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButtonCard()
    }
}
