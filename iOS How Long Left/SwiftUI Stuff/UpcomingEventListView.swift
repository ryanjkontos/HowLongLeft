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
    
    @State var scrollView: UIScrollView?
    
    @State var proxy: ScrollViewProxy?
    
    var body: some View {

        ScrollViewReader { reader in
        
            
            ScrollView {
                LazyVGrid(columns: [gridItem], alignment: .center, spacing: 5) {
                    ForEach(eventSource.events) { dateOfEvents in
                        Section(content: {
                            ForEach(dateOfEvents.events) { event in
                                NavigationLink(destination: EventView(event: event)) {
                                    
                                    UpcomingCellRepresentor(event: event, nicknaming: $nicknaming)
                                    
                                    
                                        .frame(height: 50, alignment: .center)
                                    
                                }
                                
                                .hoverEffect(.highlight)
                                
                                
                                
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
                                .drawingGroup()
                                
                                Spacer()
                                
                                VStack {
                                    
                                    Spacer()
                                    
                                    Text(getRelativeString(numberOfDays: dateOfEvents.date.daysUntil()))
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                }
                                
                                
                            }
                            .id(dateOfEvents.date)
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .padding(.horizontal, 10)
                            .drawingGroup()
                            
                        })
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 40)
                
            }
            .onReceive(SelectedTabManager.shared.reselected, perform: { _ in
                
                withAnimation {
                    
                    if let date = eventSource.events.first?.date {
                        reader.scrollTo(date)
                    }
                    
                    
                }
                
               
                
                
            })
        }
       
        
        .introspectScrollView(customize: { scrollView in
            
            self.scrollView = scrollView
            
           // scrollView.backgroundColor = .systemBackground
            
        })
        
       
       // .edgesIgnoringSafeArea(.horizontal)
        
        
        .navigationBarTitleDisplayMode(.large)
            
        .sheet(item: $nicknaming, onDismiss: nil, content: { event in
                       
            NavigationView {
                
                NickNameEditorView(NicknameObject.getObject(for: event), store: NicknameManager.shared, presenting: Binding(get: { return nicknaming != nil }, set: { _ in nicknaming = nil
                }))
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
    
  /*  func shortDayName() -> String {
        
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: date).uppercased()
        
    } */
    
   /* func dayNumber() -> String {
        
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
        
    }*/
    

}
