//
//  AnimatedGallery.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 28/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct AnimatedGallery: View {
    
    let gridItems = [
        GridItem(.fixed(200), spacing: 0),
        GridItem(.fixed(200), spacing: 0),
    ]
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State var offset: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            LazyHGrid(rows: gridItems, spacing: 0) {
                
                ForEach(1...10, id: \.self) { i in
                    
                    Image("Watch1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image("Watch2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image("Watch3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                }
               
                
                
            }
            .offset(x: CGFloat(offset))
            .onAppear(perform: {
                
                withAnimation(.linear(duration: 100)) {
                    
                    offset = -1500
                    
                }
                
            })
            
      
        
        .frame(height: 400)
            
        }
            
        
        
    }
}

struct AnimatedGallery_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedGallery()
    }
}
