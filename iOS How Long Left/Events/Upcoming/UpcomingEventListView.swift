//
//  UpcomingEventListView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 20/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct UpcomingEventListView: View {
    
    @EnvironmentObject var eventSource: UpcomingEventSource
    
    let gridItem = GridItem(.adaptive(minimum: 250, maximum: 1000), spacing: 10, alignment: .center)
    
    @Binding var eventViewEvent: HLLEvent?
    
    @State var nicknaming: HLLEvent?
    
    var body: some View {
        GeometryReader { proxy in
        ScrollView {
            LazyVGrid(columns: [gridItem], alignment: .center, spacing: 5) {
                ForEach(eventSource.events) { dateOfEvents in
                    Section(content: {
                        ForEach(dateOfEvents.events) { event in
                            NavigationLink(destination: EventView(event: event)) {
                                UpcomingSubCard(event: event)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .circular))
                                    .frame(height: 50, alignment: .center)
                                    .contentShape(.contextMenuPreview,RoundedRectangle(cornerRadius: 12, style: .circular))
                                    .modifier(CountdownCardContextMenuModifier(event: event, nicknaming: $nicknaming, reloadHandler: { eventSource.update() }))
                                    
                                }
                            .hoverEffect(.highlight)
                            .id(event.infoIdentifier)
                            .buttonStyle(SubtleRoundedPressButton(radius: 12, cornerStyle: .circular))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .circular))
                            
                        }
                        
                    }, header: {
                        
                        HStack {
                            VStack(spacing: 0) {
                                
                                Text(dateOfEvents.date.shortDayName())
                                    .font(.system(size: 12, weight: .bold, design: .default))
                                    .foregroundColor(.red)
                                Text(dateOfEvents.date.dayNumber())
                                    .font(.system(size: 30, weight: .light, design: .default))
                                    .foregroundColor(Color(uiColor: UIColor.label))
                            }
                            
                            Spacer()
                            
                            VStack {
                            
                                Spacer()
                                
                            Text(getRelativeString(numberOfDays: dateOfEvents.date.daysUntil()))
                                .foregroundColor(.secondary)
                            
                                Spacer()
                                
                            }
                            
                            
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.horizontal, 10)
                            
                    })
            }
        }
            .padding(.horizontal, proxy.safeAreaInsets.leading+20)
            .padding(.top, 10)
            .padding(.bottom, 40)
            
            
        }
       
        
        .introspectScrollView(customize: { scrollView in
            
            scrollView.backgroundColor = .systemBackground
            
        })
        .edgesIgnoringSafeArea(.horizontal)
        
        
        .navigationBarTitleDisplayMode(.large)
            
        }
        
        .sheet(item: $nicknaming, onDismiss: nil, content: { event in
            
            NavigationView {
                
                NickNameEditorView(NicknameObject.getObject(for: event), store: NicknameManager.shared, presenting: Binding(get: { return nicknaming != nil }, set: { _ in nicknaming = nil }))
                    .tint(.orange)
                
            }
            
        })
    }
    
    func getRelativeString(numberOfDays: Int) -> String {
        
        if numberOfDays == 0 {
            return "Today"
        }
        
        if numberOfDays == 1 {
            return "Tomorrow"
        }
        
        return "\(numberOfDays) days away"
        
    }
    
}

struct UpcomingEventListView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventListView(eventViewEvent: .constant(nil))
            .environmentObject(UpcomingEventSource())
    }
}

extension Date {
    
    func shortDayName() -> String {
        
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: date).uppercased()
        
    }
    
    func dayNumber() -> String {
        
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
        
    }
    
   
}
