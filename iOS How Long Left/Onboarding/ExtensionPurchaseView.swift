//
//  ExtensionPurchaseView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 29/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect
import StoreKit

struct ExtensionPurchaseView: View, Sendable {

    var type: ExtensionType
    
    @Binding var presentSheet: Bool
    
    @State var purchasing = false
    

    @ObservedObject var store = Store()
    
    var upcomingEvents = [PreviewEvent.upcomingPreviewEvent(minsStartingIn: 60, color: .systemCyan), PreviewEvent.upcomingPreviewEvent(minsStartingIn: 120, color: .systemGreen), PreviewEvent.upcomingPreviewEvent(minsStartingIn: 180, color: .systemOrange)]
    
    var current = PreviewEvent.inProgressPreviewEvent(color: .systemCyan)
    
    @State var vc: UIViewController?
    
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
            
            VStack(spacing: 20) {
                VStack(spacing: 2.5) {
                  
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
                        
                        if purchasing {
                            
                            ProgressView()
                                .progressViewStyle(.circular)
                                .frame(height: 49, alignment: .center)
                            
                        } else {
                            
                            Button(action: {
                                
                                Task {
                                    
                                    purchasing = true
                                    let purchased = await store.purchase(productFor: type)
                                    
                                    if purchased {
                                        DispatchQueue.main.async {
                                            self.presentSheet = false
                                        }
                                    }
                                    
                                    purchasing = false
                                    
                                }
                                
                                
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
                    
                    Button(action: { restore() }, label: { Text("Restore...") })
                        .foregroundColor(.secondary)
                    
                }
                .padding(.horizontal, 20)
            
            } else {
                
                EmptyView()
                
            }
        
        }
        .onAppear() {
            
          /*  withAnimation {
                
                rotateX = 90
                rotateY = 90
                
            } */
            
        }
        
        //.titleButtonPadding(height: proxy.size.height)
        }
            
            .safeAreaInset(edge: .top, content: {
                
                HStack {
                    Spacer()
                    
                    Button(action: { presentSheet = false
                        
                        vc?.dismiss(animated: true)
                        
                    }) {
                       
                       CircleXButtonView()
                        
                    }
                    
                    
                }
                .padding(.top, 20)
                .padding(.trailing, 20)
                
                
            })
            
        .frame(width: proxy.size.width, height: proxy.size.height)
       
        }
        .padding(.bottom, 20)
        .background(Color(UIColor.systemGroupedBackground))
        
   
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
                //.matchedGeometryEffect(id: "W1", in: ExtensionPurchaseParentView.animation)
                
            
            
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
            
          //  await store.restore()
            
            
        }
        
    }
 
    
}

struct ComplicationPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        ExtensionPurchaseView(type: .widget, presentSheet: .constant(true))
    }
}
