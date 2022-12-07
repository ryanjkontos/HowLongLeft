//
//  ComplicationParentView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 2/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ComplicationParentView: View {
    
  
    
    var body: some View {
        
        
        
        ComplicationPurchaseView()
        
       /* if Store.shared.extensionPurchased(oftype: .complication) {
            ComplicationsSettingsView()
        } else {
            ComplicationPurchaseView()
        } */
        
    }
}

struct ComplicationParentView_Previews: PreviewProvider {
    static var previews: some View {
        ComplicationParentView()
    }
}
