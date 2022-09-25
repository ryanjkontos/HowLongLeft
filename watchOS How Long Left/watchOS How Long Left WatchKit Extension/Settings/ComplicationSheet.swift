//
//  ComplicationSheet.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 19/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ComplicationSheet: View {
    
    @Binding var show: Bool
    
    var body: some View {
        ComplicationPurchaseView()
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction, content: {
                    
                    Button(action: { show = false }, label: { Text("Done") })
                    
                })
                
            }
    }
}

struct ComplicationSheet_Previews: PreviewProvider {
    static var previews: some View {
        ComplicationSheet(show: .constant(true))
    }
}
