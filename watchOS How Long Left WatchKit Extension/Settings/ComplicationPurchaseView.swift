//
//  ComplicationPurchaseView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 19/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ComplicationPurchaseView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        
        if store.purchasedExtenions.contains(.complication) {
            
            Text("Complication Purcahsed")
            
        } else {
        
        Button(action: {
            
            Task {
                
               try? await store.purchase(store.complicationProduct!)
                
            }
            
        }, label: { Text("Purchase - \(store.complicationProduct?.displayPrice ?? "No Price")") })
      
        
        }
    }
}

struct ComplicationPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        ComplicationPurchaseView()
    }
}
