//
//  InProgressEventsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 4/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect



struct CountdownsView: View {
    
    @EnvironmentObject var eventSource: EventSource
    @State var opacity = 0.0
    let gridItem = GridItem(.adaptive(minimum: 300, maximum: 800), spacing: 10, alignment: .leading)
   
    @Namespace var animation
    
    @Binding var eventViewEvent: HLLEvent?
    
    @State var overlayEvent: HLLEvent?
    
    var body: some View {
        
        
            ScrollView {
                LazyVGrid(columns: [gridItem], spacing: 15) {
                    ForEach(eventSource.eventSections) { section in
                        Section(content: {
                            ForEach(section.events) { event in
                                
                                NavigationLink(destination: { EventView(event: event) }, label: {
                                    
                                   CountdownCard(event: event)
                                      
                                      .contentShape(.contextMenuPreview,RoundedRectangle(cornerRadius: 20, style: .continuous))
                                      .modifier(CountdownCardContextMenuModifier(event: event, reloadHandler: { eventSource.update() }))
                                    
                                })
                                
                                    .clipped()
                                   
                                
                            /*   Button(action: { selectEvent(event: event) }, label: {
                                    CountdownCard(event: event)
                                        .frame(height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                        .contentShape(.contextMenuPreview,RoundedRectangle(cornerRadius: 30, style: .continuous))
                                        .modifier(CountdownCardContextMenuModifier(event: event))
                                        
                                        
                                    }) */
                                    
                                   .id("\(event.persistentIdentifier)\(event.isPinned)")
                                    
                                    .buttonStyle(SubtleRoundedPressButton(radius: 20, cornerStyle: .continuous))
                                    
                            }
                        }, header: {
                            HStack {
                                HeaderText(value: "\(section.title ?? "")")
                                Spacer()
                            }
                        })
                            .id(section.title)
                            
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: eventSource.eventSections)
                .opacity(opacity)
                .onAppear {
                    if opacity != 0 { return }
                    withAnimation(.easeInOut(duration: 0.1)) { opacity = 1 }
                }
                .onDisappear {
                    if eventSource.eventSections.isEmpty { withAnimation(.easeInOut(duration: 0.1)) { opacity = 0 } }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
            }
            .introspectScrollView(customize: { scrollView in
                scrollView.backgroundColor = UIColor.systemBackground
            })
            .introspectNavigationController(customize: {
                
                $0.navigationBar.barStyle = .default
                
            })
            .edgesIgnoringSafeArea(.horizontal)
        
 
        .navigationBarTitleDisplayMode(.large)
   
    }
    

    
    func selectEvent(event: HLLEvent) {
        
        eventViewEvent = event
       
        
        
    }
    
}

/*struct InProgressEventsView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownsView(eventViewEvent: .constant(.previewEvent()))
    }
} */

struct SubtleRoundedPressButton: ButtonStyle {
    
    @State var radius: CGFloat
    @State var cornerStyle: RoundedCornerStyle
    
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            
            configuration.label
            Color.black
                .clipShape(RoundedRectangle(cornerRadius: radius, style: cornerStyle))
                .opacity(configuration.isPressed ? 0.15 : 0)
            
        }
        
        
            
    }
}

struct SubtlePressButton: ButtonStyle {
    
    
    
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            
            configuration.label
            Color.black
               
                .opacity(configuration.isPressed ? 0.15 : 0)
            
        }
        
        
            
    }
}

struct ListItem: Identifiable, Hashable {
   
    var id: String { get {
        
        return name
        
    } }
    
    
    var name: String
    var color: Color
    
}
