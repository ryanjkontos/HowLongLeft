//
//  EventInfoView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 5/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import MapKit

struct EventInfoView: View {

    
    var info: LiveEventInfo
    
    @ObservedObject var dataObject: EventOptionsViewObject
    
    @State var nicknaming: HLLEvent?
    
    @Binding var presenting: Bool
    
    let gen = CountdownStringGenerator()
    
    
    init(event inputEvent: HLLEvent, presenting: Binding<Bool>) {
       
        self.info = LiveEventInfo(event: inputEvent, configuration: [.location, .start, .end, .duration, .calendar])
     
        dataObject = .init(inputEvent)
        
        _presenting = presenting
        

    }
    
    var body: some View {
        
        
        TimelineView(.periodic(from: Date(), by: .second)) { context in
            
            ScrollViewReader { reader in
            
                List {
                    
                    Section(content: {
                        
                        
                        ForEach(info.getInfoItems(at: context.date)) { item in
                            
                            VStack(alignment: .leading, spacing: 2) {
                                
                                Text("\(item.title)")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 15, weight: .light, design: .default))
                                
                                Text("\(item.info)")
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                
                                
                            }
                            
                            .listItemTint(.clear)
                        
                            
                        }
                        
                    }, header: {
                        
                        getHeader(at: context.date)
                            .padding(.vertical, 3)
                        
                        
                    })
     
                    
                    Section(content: {
                        
                        EventOptionsButtonsView(nicknaming: $nicknaming, presenting: $presenting)
                            .environmentObject(dataObject)
                        
                    }, header: {
                        
                        Text("Options")
                        
                    })
                }
           
              
                
            }
           // .listStyle(.)
           // .navigationTitle("Event")
            .padding(.horizontal, 0)
            .sheet(item: $nicknaming, onDismiss: nil, content: { event in
                           
                NavigationView {
                    
           
                    
                    NickNameEditorView(NicknameObject.getObject(for: event), store: NicknameManager.shared, presenting: Binding(get: {
                        
                        return nicknaming != nil
                        
                    }, set: { _ in
                        
                        nicknaming = nil
                        
                    }))
                        .tint(.orange)
                    }
                .onDisappear {
                    dataObject.update()
                }
                
                
                })
            
            
        }
        .onAppear {
            
            //
            
        }
                
        
    }
    
    func getHeader(at: Date) -> some View {
        
        HStack {
            
            VStack(alignment: .leading) {
            
                HStack(spacing: 8) {
                
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(Color(dataObject.event.color))
                        .frame(width: 5)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        
                        if dataObject.isPinned {
                            
                            Text("PINNED")
                            
                                .foregroundColor(Color("PinnedGold"))
                                .font(.system(size: 13, weight: .bold, design: .default))
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            
                            Text("\(dataObject.event.title)")
                                .truncationMode(.middle)
                                .lineLimit(4)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                                .font(.system(size: 19, weight: .medium, design: .default))
                            Text(getTimerText(at: at))
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .light, design: .default))
                            
                        }
                    }
                    .padding(.vertical, 3)
                    
                }
               
                .padding(.top, 0)
                .padding(.bottom, 5)
            
               
            
                
            }
            
            
            
            Spacer()
            
        }
        
        .textCase(.none)
   
    }
    
    func getTimerText(at: Date) -> String {
        
        if dataObject.event.completionStatus(at: at) == .done {
            return "Ended"
        } else {
            return "\(dataObject.event.countdownTypeString(at: at).capitalizingFirstLetter()) \(gen.generateCountdownTextFor(event: dataObject.event).justCountdown)"
        }
        
    }
    
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
            NavigationView {
                EventInfoView(event: .previewEvent(), presenting: .constant(false))
            }
        
    }
}

