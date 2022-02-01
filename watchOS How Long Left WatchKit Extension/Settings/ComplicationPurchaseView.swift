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
        
        Text("Complication")
    }
}

struct ComplicationPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        ComplicationPurchaseView()
    }
}
