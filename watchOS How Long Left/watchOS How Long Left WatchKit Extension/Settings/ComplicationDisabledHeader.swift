//
//  ComplicationDisabledHeader.swift
//  How Long Left
//
//  Created by Ryan Kontos on 30/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ComplicationDisabledHeader: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            HStack {
                
                Spacer()
                
                Image(systemName: "watchface.applewatch.case")
                    .font(.system(size: 55))
                    .foregroundColor(.orange)
                    
              
                Spacer()
                
            }
           
            
            VStack(alignment: .leading, spacing: 4) {
                    
            
                    Text("Watch Complication")
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                   
                    
                Text("How Long Left, on your Watch face. Avaliable for purchase in the iPhone app.")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
                    .minimumScaleFactor(0.6)
                    
           
            }
            
         
            
        }
        .padding(.horizontal, 5)
        
    }
}

struct ComplicationDisabledHeader_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScrollView {
                ComplicationDisabledHeader()
            }
        }
        
    }
}
