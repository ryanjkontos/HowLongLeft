//
//  DefaultMenuView.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 26/11/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

@available(OSX 10.15, *)
struct DefaultMenuView: View {
    
    @Binding var state: Bool
    @State var showPopover = false
    
    var body: some View {
        

        
        VStack(spacing: 0) {
        
            VStack(alignment: .center) {
                
                
                HStack {
                
                Text("How Long Left")
                    .font(.system(size: 13, weight: .semibold, design: .default))
                    
                    Spacer()
                    
                }
                
         
                
            }
            //.background(Color.blue)
            .padding(.top, 10)
            .padding(.bottom, 15)
            .padding(.horizontal, 16)
            
            Divider()
                .padding(.horizontal, 16)
            
       ScrollView {

           
            HStack {
            
                
            Text("Current")
                .font(.system(size: 12.1, weight: .semibold, design: .default))
                .opacity(0.69)
                .padding(.horizontal, 16)
            Spacer()
                
            }
            .frame(height: 20)
                
            
            
            DefaultMenuListItem()
            DefaultMenuListItem()
            DefaultMenuListItem()
            DefaultMenuListItem()
       
            
            
        }
        
        .padding(.vertical, 5)
        
        
        .background(Color.clear)
            
        }
        //.background(Color.green)
        //.padding(.vertical, -10)
        .edgesIgnoringSafeArea(.all)

        
    }
}



@available(OSX 10.15, *)
struct ClickableSwiftUIView: NSViewRepresentable {
    func updateNSView(_ nsView: ClickableView, context: NSViewRepresentableContext<ClickableSwiftUIView>) {
        print("Update")
    }

    func makeNSView(context: Context) -> ClickableView {
        ClickableView()
    }

}

class ClickableView: NSView {
    override func mouseDown(with theEvent: NSEvent) {
        print("left mouse")
    }

    
}
