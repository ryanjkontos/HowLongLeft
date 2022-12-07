//
//  WatchScreenshotView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 2/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct WatchScreenshotView: View {
    var body: some View {
        
        Image("CS1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(28) // Inner corner radius
            .padding(8) // Width of the border
            .background(Color(UIColor.black))
            .cornerRadius(20)
            .padding(2.5)
            .background(Color(UIColor.darkGray))
            .cornerRadius(20)
           
        
            
                
        
        
        
    }
}

struct WatchScreenshotView_Previews: PreviewProvider {
    static var previews: some View {
        WatchScreenshotView()
    }
}
