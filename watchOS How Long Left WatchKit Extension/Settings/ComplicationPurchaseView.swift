//
//  ComplicationPurchaseView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 19/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ComplicationPurchaseView: View {
    
    @ObservedObject var store = Store.shared
    
    var body: some View {
        
        if store.complicationPurchased {
            ComplicationsSettingsView()
        } else {
            Button(action: { triggerPurchase() }, label: { Text("Purchase Complication") })
                .buttonStyle(.borderedProminent)
                .tint(.orange)
        }
        
    }
    
    func triggerPurchase() {
        Task {
            await store.purchase(productFor: .complication)
        }
    }
    
}

struct ComplicationPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        ComplicationPurchaseView()
    }
}
