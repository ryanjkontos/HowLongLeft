//
//  ComplicationParentView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 2/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ComplicationParentView: View {
    
    @ObservedObject var store = Store.shared
    
    var body: some View {
        
        if true {
            ComplicationsSettingsView()
        } else {
            ComplicationPurchaseView()
        }
        
    }
}

struct ComplicationParentView_Previews: PreviewProvider {
    static var previews: some View {
        ComplicationParentView()
    }
}
