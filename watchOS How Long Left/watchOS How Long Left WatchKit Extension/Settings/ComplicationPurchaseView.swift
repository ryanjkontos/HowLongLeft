//
//  ComplicationPurchaseView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 19/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ComplicationPurchaseView: View {
    
    @State var purchasing = false
    
    
    
    var body: some View {


        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HStack {
                            
                            Image(systemName: "watchface.applewatch.case")
                                .font(.system(size: 53))
                                .foregroundColor(.orange)
                                
                            
                            Spacer()
                            
                            Button(action: { triggerPurchase() }, label: {
                                
                                if !purchasing {
                                
                                Text("$2.99")
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .foregroundColor(.white)
                                    .background {
                                        
                                        Capsule()
                                            .foregroundColor(.orange)
                                            
                                 
                                    }
                                    
                                } else {
                                    
                                  
                                    IndeterminateProgressCircle()
                                        
                                    
                                }
                                    
                                
                            })
                            .buttonStyle(.borderless)
                            
                            
                        }
                        .padding(.trailing, 10)
                        
                        VStack(alignment: .leading, spacing: 1) {
                                
                        
                                Text("Watch Complication")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                                
                            Text("How Long Left, on your Watch face.")
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.secondary)
                                
                       
                        }
                        
                     
                        
                    }
                    .padding(.horizontal, 5)
                    
                    
                    VStack {
                        VStack {
                            
                
                        
                        Button(action: { triggerRestore() }, label: { Text("Restore") })
                        .buttonStyle(.bordered)
                        .tint(.gray)

                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    VStack(alignment: .leading ,spacing: 14) {
                        
                        Text("Screenshots")
                            .fontWeight(.semibold)
                            .padding(.leading, 2)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                        
                        LazyHStack {
                            
                            WatchScreenshotView()
                                .frame(width: proxy.size.width-30)
                            WatchScreenshotView()
                                .frame(width: proxy.size.width-30)
                            WatchScreenshotView()
                                .frame(width: proxy.size.width-30)
                            
                        }
                       
                        }
                    }
                    .padding(.top, 6)
                    
                     
                }
            }
        }
            
        
        
    }
    
    func triggerPurchase() {
        
        withAnimation {
            purchasing.toggle()
        }
        
        Task {
           // await Store.shared.purchase(productFor: .complication)
        }
    }
    
    func triggerRestore() {
        Task {
            //await Store.shared.refreshPurchasedProducts()
        }
    }
    
}

struct ComplicationPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        ComplicationPurchaseView()
        }
    }
}
