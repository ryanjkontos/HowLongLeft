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
    
    @Binding var launchEvent: HLLEvent?
    
    @State var overlayEvent: HLLEvent?
    
    @State var eventView = false
    
    @State var nicknaming: HLLEvent?
    
    @State var id = 0
    
    @State var activeEvent: HLLEvent?
    
    var body: some View {
        
        ScrollViewReader { reader in
            
            ScrollView {
                
                LazyVGrid(columns: [gridItem], spacing: 15) {
                    ForEach(eventSource.eventSections) { section in
                        Section(content: {
                            ForEach(section.events) { event in
                                
                                
                                
                                NavigationLink(destination: EventView(event: event)) {
                                    
                                    
                                    CountdownCardRepresentor(event: event, nicknaming: $nicknaming, eventSource: eventSource)
                                        .frame(height: 123)
                                    //.drawingGroup()
                                        .contentShape(.contextMenuPreview,RoundedRectangle(cornerRadius: 30, style: .continuous))
                                    
                                }
                                .id(event.persistentIdentifier)
                                
                                
                                
                                //.modifier(CountdownCardContextMenuModifier(event: event, nicknaming: $nicknaming, reloadHandler: { eventSource.update() }))
                                
                                .hoverEffect(.highlight)
                                
                                //  .clipped()
                                .buttonStyle(SubtleRoundedPressButton(radius: 30, cornerStyle: .continuous))
                                
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
                .transition(.identity)
                .animation(.easeInOut(duration: 0.3), value: eventSource.eventSections)
                
                //.opacity(opacity)
                .onAppear {
                    
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        eventSource.allowUpdates = true
                        eventSource.update()
                    }
                    
                    //  if opacity != 0 { return }
                    // withAnimation(.easeInOut(duration: 0.1)) { opacity = 1 }
                    
                }
                .onDisappear {
                    eventSource.allowUpdates = false
                    if eventSource.eventSections.isEmpty { withAnimation(.easeInOut(duration: 0.1)) { opacity = 0 } }
                }
                .onChange(of: eventSource.eventSections) { data in
                    
                    DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 1) {
                        DispatchQueue.main.async {
                            id += 1
                        }
                    }
                    
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
            }
            
            
            .introspectScrollView(customize: { scrollView in
                scrollView.backgroundColor = UIColor.systemBackground
            })
            
            .onReceive(SelectedTabManager.shared.reselected, perform: { _ in
                
                withAnimation {
                    
                    if let date = eventSource.eventSections.first?.title {
                        reader.scrollTo(date)
                    }
                    
                    
                }
            })
            
        }
            .introspectNavigationController(customize: {
                
                $0.navigationBar.barStyle = .default
            
                $0.navigationBar.prefersLargeTitles = true
                $0.navigationItem.largeTitleDisplayMode = .always
            })
            
            
          //  .edgesIgnoringSafeArea(.horizontal)
        
        .sheet(item: $nicknaming, onDismiss: nil, content: { event in
                       
            NavigationView {
                
                NickNameEditorView(NicknameObject.getObject(for: event), store: NicknameManager.shared, presenting: Binding(get: { return nicknaming != nil }, set: { _ in nicknaming = nil
                }))
                    .tint(.orange)
                }
            })
            
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

