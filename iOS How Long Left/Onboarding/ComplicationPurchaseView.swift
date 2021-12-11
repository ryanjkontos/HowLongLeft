//
//  ComplicationPurchaseView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 29/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ComplicationPurchaseView: View {

    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
        VStack {
            
            VStack(spacing: 15) {
                VStack(spacing: 5) {
                  
                    Text("Watch Complication")
                        .font(.system(size: 35, weight: .bold, design: .default))
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                    
                        
                    Text("How Long Left, on your Apple Watch face.")
                        .font(.system(size: 18, weight: .regular, design: .default))
                        
                    
                }
                .multilineTextAlignment(.center)
                
                
                Button(action: { }, label: {
                    
                    Text("Learn More...")
                        .fontWeight(.medium)
                    
                    
                })
                    .foregroundColor(.orange)
                
            }
            
           
            
            Spacer()
            
            Image("W1")
                .resizable()
                .scaledToFit()
                .frame(width: 185)
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 5)
                .padding(.vertical, 15)
                
            
            Spacer()
            
            VStack(spacing: 6.5) {
                
                NavigationLink(destination: { EmptyView() }, label: {
                    
                    Text("Purchase – $2.99")
                        .font(.headline)
                        .frame(maxWidth: 300)
                    
                })
                .tint(.orange)
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                .frame(height: 49, alignment: .center)
                
                NavigationLink(destination: { EmptyView() }, label: {
                    
                    Text("Not Now")
                        .font(.headline)
                        .frame(maxWidth: 300)
                    
                })
                .tint(.secondary)
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                .frame(height: 49, alignment: .center)
                
                
            }
        
        }
        .padding(.horizontal, 20)
        .titleButtonPadding(height: proxy.size.height)
        }
            
        .frame(width: proxy.size.width, height: proxy.size.height)
       
        }
        
    }
    
    func getTopTextSize(viewHeight height: CGFloat) -> CGFloat {
        
        print("Height: \(height)")
        
        
        if height < 550 {
            return 29
        }
        
        return 34
        
    }
    
 
    
}

struct ComplicationPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        ComplicationPurchaseView()
    }
}
