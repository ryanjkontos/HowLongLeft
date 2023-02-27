//
//  ExtensionPurchaseViewLandscape.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect
import StoreKit

struct ExtensionPurchaseViewLandscape: View {
    
    @State var vc: UIViewController?
    
    var type: ExtensionType
    
    var upcomingEvents = [PreviewEvent.upcomingPreviewEvent(minsStartingIn: 60, color: .systemCyan), PreviewEvent.upcomingPreviewEvent(minsStartingIn: 120, color: .systemGreen), PreviewEvent.upcomingPreviewEvent(minsStartingIn: 180, color: .systemOrange)]
    
    var current = PreviewEvent.inProgressPreviewEvent(color: .systemCyan)
    
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
            
          getPreviewView()
           
            
        }
        .padding(.top)
        .padding(.horizontal, 40)
       
        .overlay {
            
            VStack {
                
                HStack {
                    Spacer()
                    Button(action: {
                        vc?.dismiss(animated: true)
                    }, label: {
                        CircleXButtonView()
                            .padding(.top, 25)
                            .padding(.trailing, 25)
                    })
                    
                }
                
                Spacer()
                
            }
            .edgesIgnoringSafeArea(.all)
            
        }
       
        .introspectViewController(customize: { viewController in
            
            vc = viewController
            
        })
        
        
    }
    
    @ViewBuilder func getPreviewView() -> some View {
        
        switch type {
        case .widget:

            WidgetsPreviewView(current: current, upcomingEvents: upcomingEvents)
               
            
        case .complication:
            
            Image("W1")
                .resizable()
                .scaledToFit()
                .frame(width: 185)
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 5)
                .padding(.vertical, 15)
                
            
        }
        
    }
    
    var infoHeader: some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            Text(getTitle())
                .font(.system(size: 41, weight: .bold, design: .default))
                .lineLimit(1)
                .minimumScaleFactor(0.2)
                .multilineTextAlignment(.center)
            
            Text(getDescription())
                .foregroundColor(.secondary)
                .font(.system(size: 19, weight: .regular, design: .default))
                .multilineTextAlignment(.center)
            
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
                        
                        Text(getPurchaseString())
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
    
    func getTitle() -> String {
        
        switch type {
        case .widget:
            return "Home Screen Widget"
        case .complication:
            return "Watch Complication"
        }
        
    }
    
    func getDescription() -> String {
        
        switch type {
        case .widget:
            return "How Long Left, on your Home Screen."
        case .complication:
            return "How Long Left, on your Apple Watch face."
        }
        
    }
    
    
    func getPurchaseString() -> String {
        
        var product: Product?
        
        switch type {
        case .widget:
            product = Store.shared.widgetProduct
        case .complication:
            product = Store.shared.complicationProduct
        }
        
        if let product = product {
            return "Purchase - \(product.displayPrice)"
        }
        
        return "Purchase"
    }
    
}

struct ExtensionPurchaseViewLandscape_Previews: PreviewProvider {
    static var previews: some View {
        ExtensionPurchaseViewLandscape(type: .complication)
    }
}
