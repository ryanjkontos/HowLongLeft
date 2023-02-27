//
//  WelcomeView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 21/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var store: Store
    
       
    var body: some View {
        
        GeometryReader { proxy in
            
            ZStack {
                
                VStack {
                
                Text("Welcome To How Long Left")
                        .font(.system(size: 35, weight: .bold, design: .default))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    //.interactiveDismissDisabled(true)
                
                    Spacer()
                  
                    NavigationLink(destination: { WelcomeRoutingView(source: .welcome) }, label: {
                        
                        Text("Next")
                            .font(.headline)
                            .frame(maxWidth: 300)
                        
                    })
                        .tint(.orange)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .padding(.horizontal, 20)
                        .frame(height: 52, alignment: .center)
                        .navigationBarHidden(true)
                    
                }
                .padding(.top, getTopPadding(viewHeight: proxy.size.height))
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                
            }
            
            .frame(width: proxy.size.width, height: proxy.size.height)
            
        }
        
    }
    
    func getTopPadding(viewHeight height: CGFloat) -> CGFloat {
        
        
        if height < 550 {
            return 30
        }
        
        return 40
        
    }
    
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(Store())
    }
}
