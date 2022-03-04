//
//  TextFieldLis.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 21/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct TextFieldLis: View {
    var body: some View {
        
        List {
            
            TextField("", text: .constant("Text"))
                .padding(.trailing, 35)
                .overlay { HStack {
                    
                    Spacer()
                    
                    
                    Button(action: {
                        
                    }, label: {
                        
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(.orange)
                        
                    })
                    
                    
                } }
            
        }
        
    }
}

struct TextFieldLis_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldLis()
    }
}
