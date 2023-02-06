//
//  WatchWelcomeMainView.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 31/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct WatchWelcomeMainView: View {
    
    @State private var isShowing = false
    
    var body: some View {
       
        VStack(alignment: .leading) {
            
            Text("Welcome To")
            
            Text("How Long Left")
                .font(Font.system(size: 25, weight: .bold))
                .multilineTextAlignment(.center)
                
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        self.isShowing = true
                    }
                   
                }
                .foregroundStyle(

                        LinearGradient(
                            colors: [.red, .orange, .yellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            
            ProgressView()
                .progressViewStyle(.circular)
            
        }
        .opacity(isShowing ? 1 : 0)
        .offset(y: isShowing ? 0 : 50)
        
        
        
        
    }
}

struct WatchWelcomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        WatchWelcomeMainView()
    }
}
