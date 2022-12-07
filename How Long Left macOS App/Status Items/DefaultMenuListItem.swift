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
                .frame(height: 26)
                .foregroundColor(col)
            
                
            
            
            HStack {
                
                ProgressRing()
                    .frame(width: 20, height: 20)
                
                if #available(macOS 12.0, *) {
                    Text("Event ends in 5 minutes (50%)")
                        .foregroundColor(Color(cgColor: NSColor.textColor.cgColor))
                        .font(.system(size: 13.8, weight: .regular, design: .default))
                } else {
                    // Fallback on earlier versions
                }
                
                Spacer()
                
                
            }
            .whenHovered({ hovering in
                
                withAnimation(Animation.easeInOut(duration: 0.01), {
                    
                    if hovering {
                        col = Color.gray.opacity(0.32)
                    } else {
                        col = Color.clear
                    }
                    
                })
                
            })
            
            
                
            
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
        // print("Update")
    }

    func makeNSView(context: Context) -> RightClickableView {
        RightClickableView()
    }

}

class RightClickableView : NSView {
    override func mouseDown(with theEvent: NSEvent) {
        // print("left mouse")
    }

    override func rightMouseDown(with theEvent: NSEvent) {
        // print("right mouse")
    }
    
    private var isMouseOverTheView = false {
          didSet {
             backgroundColor = isMouseOverTheView ? .red : .green
          }
       }
       private lazy var area = makeTrackingArea()
       private var backgroundColor: NSColor? {
          didSet {
             setNeedsDisplay(bounds)
          }
       }

       init() {
          super.init(frame: NSRect()) // Zero frame. Assuming that we are in autolayout environment.
          isMouseOverTheView = false
       }

       required init?(coder: NSCoder) {
          fatalError()
       }

       public override func updateTrackingAreas() {
          removeTrackingArea(area)
          area = makeTrackingArea()
          addTrackingArea(area)
       }

       public override func mouseEntered(with event: NSEvent) {
          isMouseOverTheView = true
       }

       public override func mouseExited(with event: NSEvent) {
          isMouseOverTheView = false
       }

       private func makeTrackingArea() -> NSTrackingArea {
          return NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeInKeyWindow], owner: self, userInfo: nil)
       }

       open override func draw(_ dirtyRect: NSRect) {
          if let backgroundColor = backgroundColor {
             backgroundColor.setFill()
             dirtyRect.fill()
          } else {
             super.draw(dirtyRect)
          }
       }
}

struct MouseInsideModifier: ViewModifier {
    let mouseIsInside: (Bool) -> Void
    
    init(_ mouseIsInside: @escaping (Bool) -> Void) {
        self.mouseIsInside = mouseIsInside
    }
    
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { proxy in
                Representable(mouseIsInside: mouseIsInside,
                              frame: proxy.frame(in: .global))
            }
        )
    }
    
    private struct Representable: NSViewRepresentable {
        let mouseIsInside: (Bool) -> Void
        let frame: NSRect
        
        func makeCoordinator() -> Coordinator {
            let coordinator = Coordinator()
            coordinator.mouseIsInside = mouseIsInside
            return coordinator
        }
        
        class Coordinator: NSResponder {
            var mouseIsInside: ((Bool) -> Void)?
            
            override func mouseEntered(with event: NSEvent) {
                mouseIsInside?(true)
            }
            
            override func mouseExited(with event: NSEvent) {
                mouseIsInside?(false)
            }
        }
        
        func makeNSView(context: Context) -> NSView {
            let view = NSView(frame: frame)
            
            let options: NSTrackingArea.Options = [
                .mouseEnteredAndExited,
                .inVisibleRect,
                .activeAlways,
                .enabledDuringMouseDrag,
                .mouseMoved,
                
            ]
            
            let trackingArea = NSTrackingArea(rect: frame,
                                              options: options,
                                              owner: context.coordinator,
                                              userInfo: nil)
            
            view.addTrackingArea(trackingArea)
            
            return view
        }
        
        func updateNSView(_ nsView: NSView, context: Context) {}
        
        static func dismantleNSView(_ nsView: NSView, coordinator: Coordinator) {
            nsView.trackingAreas.forEach { nsView.removeTrackingArea($0) }
        }
    }
}

extension View {
    func whenHovered(_ mouseIsInside: @escaping (Bool) -> Void) -> some View {
        modifier(MouseInsideModifier(mouseIsInside))
    }
}
