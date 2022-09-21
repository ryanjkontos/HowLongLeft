//
//  ExtensionPurchaseParentView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ExtensionPurchaseParentView: View {
    
    @Namespace static var animation
    
    var body: some View {
        
        
        
            ExtensionPurchaseView(type: .complication, presentSheet: .constant(false))
           
         
    }
}

struct ExtensionPurchaseParentView_Previews: PreviewProvider {
    static var previews: some View {
        ExtensionPurchaseParentView()
    }
}
