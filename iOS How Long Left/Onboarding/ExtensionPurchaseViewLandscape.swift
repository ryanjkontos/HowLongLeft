//
//  ExtensionPurchaseViewLandscape.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct ExtensionPurchaseViewLandscape: View {
    
    @State var vc: UIViewController?
    
    
    
    var body: some View {
        
        HStack {
            
            HStack {
                
               
               
                VStack {
                    
            
                    infoHeader
                        
                    Spacer()
                    buttonFooter
                    
                }
                .padding(.vertical, 30)
                
                Spacer()
               
                
            }
          extensionPreviewView
            
           
            
        }
        .padding(.top)
        .padding(.horizontal, 40)
        .background {
            
        }
       // .edgesIgnoringSafeArea(.bottom)
      /*  .safeAreaInset(edge: .trailing, content: {
            
            HStack {
                Spacer()
                Button(action: {
                    vc?.dismiss(animated: true)
                }, label: {
                    CircleXButtonView()
                })
                
            }
           
            
        }) */
        .introspectViewController(customize: { viewController in
            
            vc = viewController
            
        })
        
        
    }
    
    var extensionPreviewView: some View {
        
        Image("W1")
            .resizable()
            .scaledToFit()
            .shadow(radius: 5)
            .padding(.vertical, 20)
            
        
    }
    
    var infoHeader: some View {
        
        VStack(spacing: 15) {
            
            Text("Watch Complication")
                .font(.system(size: 41, weight: .bold, design: .default))
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            
            Text("How Long Left, on your Apple Watch face.")
                .foregroundColor(.secondary)
                .font(.system(size: 19, weight: .regular, design: .default))
            
        }
        
    }
    
    var buttonFooter: some View {
        
        VStack(spacing: 20) {
            VStack(spacing: 6.5) {
                
                if false {
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(height: 49, alignment: .center)
                    
                } else {
                    
                    Button(action: {
                        
           
                        
                        
                    }, label: {
                        
                        Text("Buy")
                            .font(.headline)
                            .frame(maxWidth: 300)
                        
                    })
                    .tint(.orange)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .frame(height: 49, alignment: .center)
                    
                }
                
        
            
            
            
            
            
            }
            
            Button(action: {
                //restore()
                
            }, label: { Text("Restore...") })
            //.buttonStyle(.borderedProminent)
            
                .foregroundColor(.secondary)
            
        }
        
    }
}

struct ExtensionPurchaseViewLandscape_Previews: PreviewProvider {
    static var previews: some View {
        ExtensionPurchaseViewLandscape()
    }
}
