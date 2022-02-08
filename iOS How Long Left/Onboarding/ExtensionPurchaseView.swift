//
//  ExtensionPurchaseView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 29/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct ExtensionPurchaseView: View {

    var type: ExtensionType
    
    @Binding var presentSheet: Bool
    
    @ObservedObject var store = Store.shared
    
    @State var upcomingEvents = [PreviewEvent.upcomingPreviewEvent(minsStartingIn: 60, color: .systemCyan), PreviewEvent.upcomingPreviewEvent(minsStartingIn: 120, color: .systemGreen), PreviewEvent.upcomingPreviewEvent(minsStartingIn: 180, color: .systemOrange)]
    
    @State var current = PreviewEvent.inProgressPreviewEvent(color: .systemCyan)
    
    
    init(type: ExtensionType, presentSheet: Binding<Bool>) {
        
        _presentSheet = presentSheet
        self.type = type
        
        UIPageControl.appearance().currentPageIndicatorTintColor = .label.withAlphaComponent(0.99)
        UIPageControl.appearance().pageIndicatorTintColor = .label.withAlphaComponent(0.3)
        
    }
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                
        VStack {
            
            VStack(spacing: 15) {
                VStack(spacing: 5) {
                  
                    Text(getTitle())
                        .font(.system(size: 35, weight: .bold, design: .default))
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                    
                        
                    Text(getDescription())
                        .foregroundColor(.secondary)
                        .font(.system(size: 18, weight: .regular, design: .default))
                        
                    
                }
                .multilineTextAlignment(.center)
                
                
                Button(action: { }, label: {
                    
                    Text("Learn More...")
                        .fontWeight(.medium)
                    
                    
                })
                    .foregroundColor(.orange)
                
            }
            .padding(.horizontal, 20)
            
           
            
            Spacer()
            
            getPreviewView()
            
            Spacer()
            
            if !store.extensionPurchased(oftype: type) {
            
                VStack(spacing: 20) {
                    VStack(spacing: 6.5) {
                    
                    Button(action: {
                        
                        Task {
                            
                            let purchased = await store.purchase(productFor: type)
                            
                            if purchased {
                                DispatchQueue.main.async {
                                    self.presentSheet = false
                                }
                            }
                            
                        }
                        
                        
                    }, label: {
                        
                        Text("Purchase – $2.99")
                            .font(.headline)
                            .frame(maxWidth: 300)
                        
                    })
                    .tint(.orange)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    .frame(height: 49, alignment: .center)
                    
                      
                    
                    }
                    
                    Button(action: { restore() }, label: { Text("Restore...") })
                        .foregroundColor(.secondary)
                    
                }
                .padding(.horizontal, 20)
            
            } else {
                
                Text("Already Purchased")
                
            }
        
        }
        .onAppear() {
            
          /*  withAnimation {
                
                rotateX = 90
                rotateY = 90
                
            } */
            
        }
        
        .titleButtonPadding(height: proxy.size.height)
        }
            
        .frame(width: proxy.size.width, height: proxy.size.height)
       
        }
        .background(.regularMaterial)
        .introspectViewController(customize: { viewController in
            
            viewController.view.backgroundColor = .clear
            //viewController.view.superview?.backgroundColor = .clear
            
        })
        
    }
    
    @ViewBuilder func getPreviewView() -> some View {
        
        switch type {
        case .widget:

            WidgetsPreviewView(current: $current, upcomingEvents: $upcomingEvents)
               
            
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
    
    
    func getTopTextSize(viewHeight height: CGFloat) -> CGFloat {
        
        print("Height: \(height)")
        
        
        if height < 550 {
            return 29
        }
        
        return 34
        
    }
    
    
    func restore() {
        
        Task {
            
            await store.restore()
            
            
        }
        
    }
 
    
}

struct ComplicationPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        ExtensionPurchaseView(type: .widget, presentSheet: .constant(true))
    }
}
