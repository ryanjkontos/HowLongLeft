//
//  ProgressBar.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 30/11/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
   
    var percent: Double
    var color: Color
    
    private var divisor: Double {
        
        get {
            
            return Double(100)/Double(percent)
            
        }
        
    }
    
    var body: some View {
        
        ZStack {
            
            GeometryReader { proxy in
            
            Rectangle()
               
                .foregroundColor(color.opacity(0.33))
            
                
                if divisor > 0 {
                
            Rectangle()
                
                .brightness(-0.05)
                .foregroundColor(color.opacity(0.8))
                .frame(width: proxy.size.width/CGFloat(divisor))
                
                
            }
                
            }
            
          //  Text("\(percent)")
            
        }
        .cornerRadius(5)
        
 
    }
    
    
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(percent: 50, color: .HLLOrange)
    }
}
