//
//  WidgetPreferencesView.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 3/12/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

@available(OSX 11, *)
struct WidgetPreferencesView: View {
    
    @State var showSelected = false
    @State var animate = false
    
    var body: some View {
        
        VStack {
        
            HStack {
                
                HStack {
                
                Button("Refresh Widgets", action: {
                    
                    animate = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        
                        animate = false
                        
                    }
                    
                })

                    
                    ActivityIndicatorView(isAnimating: $animate, style: .spinning)
                        .frame(width: 5, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .opacity(animate ? 1.0 : 0.0)
                        
                    
                    
                }
                
            }
            
        Divider()
            .padding(.horizontal, 20)
            
        Toggle("Show Selected Events", isOn: $showSelected)
            .toggleStyle(CheckboxToggleStyle())
            
        }
        .frame(width: 500, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

@available(OSX 11, *)
struct WidgetPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetPreferencesView()
            .previewLayout(.fixed(width: 500, height: 500))
            
            
    }
}


@available(OSX 10.15, *)
struct ActivityIndicatorView: NSViewRepresentable {
    @Binding var isAnimating: Bool
    let style: NSProgressIndicator.Style
    
    func makeNSView(context: NSViewRepresentableContext<ActivityIndicatorView>) -> NSProgressIndicator {
        let i = NSProgressIndicator(frame: NSRect(x: 0, y: 0, width: 5, height: 5))
        i.style = style
        
        return i
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: NSViewRepresentableContext<ActivityIndicatorView>) {
        isAnimating ? nsView.startAnimation(nil) : nsView.stopAnimation(nil)
    }
}
