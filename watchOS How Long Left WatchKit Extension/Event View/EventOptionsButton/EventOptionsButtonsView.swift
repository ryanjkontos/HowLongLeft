//
//  EventOptionsButtonsView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 22/6/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventOptionsButtonsView: View {
    
    let columns = [
        GridItem(.flexible(minimum: 60, maximum: 75)),
        GridItem(.flexible(minimum: 60, maximum: 75))
       ]
    
    var body: some View {
        
        ScrollView {
        
        LazyVGrid(columns: columns, spacing: 20) {
            
            EventOptionsButtonView(label: "Pin", symbol: "pin.fill", color: .yellow) {
                print("Action")
                
            }
            
            
            EventOptionsButtonView(label: "Nickname", symbol: "pencil", color: .blue) {
                print("Action")
            }
            
            EventOptionsButtonView(label: "Hide", symbol: "eye.slash.fill", color: .purple) {
                print("Action")
            }
            
            EventOptionsButtonView(label: "Hide Calendar", symbol: "eye.slash.fill", color: .purple) {
                print("Action")
            }
            
        }
        .padding(.top, 10)
            
        }
        
    }
}

struct EventOptionsButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        EventOptionsButtonsView()
            
    }
}
