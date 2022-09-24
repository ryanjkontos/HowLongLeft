//
//  ExtensionPurchaseParentView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ExtensionPurchaseParentView: View {
    
    var type: ExtensionType
    
    var body: some View {
        
        GeometryReader { proxy in
            
            if proxy.size.width > proxy.size.height {
                ExtensionPurchaseViewLandscape(type: type)
            } else {
                ExtensionPurchaseView(type: type, presentSheet: .constant(false))
            }
            
            
            
        }
           
         
    }
}

struct ExtensionPurchaseParentView_Previews: PreviewProvider {
    static var previews: some View {
        ExtensionPurchaseParentView(type: .complication)
    }
}
