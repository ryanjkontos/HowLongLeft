//
//  MenuContainerView.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 26/11/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

@available(OSX 10.15, *)
struct MenuContainerView: View {
    
    @State var detail = false
    
    var body: some View {
        
        if detail {
            
            Text("Detail")
                .transition(.slide)
            
        } else {
            DefaultMenuView(state: $detail)
                .transition(.slide)
        }
        
        
    }
}

@available(OSX 10.15, *)
struct MenuContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MenuContainerView()
    }
}
