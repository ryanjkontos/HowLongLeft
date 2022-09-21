//
//  CountdownsListWidget.swift
//  iOSWidgetExtension
//
//  Created by Ryan Kontos on 15/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WidgetKit

struct CountdownsListWidget: View {
    var body: some View {
        
        VStack(spacing: 3) {
            
            ForEach(0..<3, content: {_ in
                
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor([Color.cyan, Color.mint, Color.red].randomElement()).opacity(0.3)
                    .frame(height: 40)
                    .overlay(content: {
                        
                        
                        HStack {
                            
                            VStack(alignment: .leading) {
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("Event")
                                        .foregroundColor(.black)
                                        .font(.system(size: 13, weight: .medium, design: .default))
                                        
                                    
                                    Text("ends in")
                                        .foregroundColor(.black)
                                        .font(.system(size: 11, weight: .medium, design: .default))
                                        
                                    
                                    
                                }
                                
                               
                                    
                               

                            }
                            
                            Spacer()
                            
                            Text("00:00")
                                .foregroundColor(.black)
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                //.shadow(radius: 3)
                            
                            
                            
                           
                            
                        }
                        .padding(.horizontal, 10)
                        
                        
                        
                    })
                
                
            })
            
          
          
            
            
        }
        .padding(.horizontal, 10)
        
    }
}

struct CountdownsListWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            CountdownsListWidget()
        }
       
        //.previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
