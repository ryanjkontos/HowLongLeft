//
//  DefaultMenuListItem.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 26/11/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

@available(OSX 10.15, *)
struct DefaultMenuListItem: View {
    
    @State var col = Color.clear
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 4)
                .frame(height: 30)
                .foregroundColor(col)
                .onHover(perform: { hovering in
                    
                    withAnimation(Animation.easeInOut(duration: 0.01), {
                        
                        if hovering {
                            col = Color.gray.opacity(0.32)
                        } else {
                            col = Color.clear
                        }
                        
                    })
                    
                    
                })
            
            HStack {
                
                ProgressRing()
                    .frame(width: 17, height: 17)
                
                Text("Event ends in 5 minutes (50%)")
                
                Spacer()
                
                
            }
            
            RightClickableSwiftUIView()
                
            
        }
        
    }
}

@available(OSX 10.15, *)
struct DefaultMenuListItem_Previews: PreviewProvider {
    static var previews: some View {
        DefaultMenuListItem()
    }
}

@available(OSX 10.15, *)
struct RightClickableSwiftUIView: NSViewRepresentable {
    func updateNSView(_ nsView: RightClickableView, context: NSViewRepresentableContext<RightClickableSwiftUIView>) {
        print("Update")
    }

    func makeNSView(context: Context) -> RightClickableView {
        RightClickableView()
    }

}

class RightClickableView : NSView {
    override func mouseDown(with theEvent: NSEvent) {
        print("left mouse")
    }

    override func rightMouseDown(with theEvent: NSEvent) {
        print("right mouse")
    }
}
