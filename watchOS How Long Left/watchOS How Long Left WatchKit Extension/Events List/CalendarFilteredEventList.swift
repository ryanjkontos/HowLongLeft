//
//  CalendarFilteredEventList.swift
//  How Long Left watch App WatchKit Extension
//
//  Created by Ryan Kontos on 19/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CalendarFilteredEventList: View {
    
    @ObservedObject var dataSource: EventsListDataSource
    @Environment(\.scenePhase) private var scenePhase
    
    @State var timelineStart: Date!
    let loadDate = Date()
    
    @State var disappearDate: Date?
    @State var showSettings = false
    @State var calendarFilterID: String?
    
    var body: some View {
    
        ZStack {
            
            Group {
                
                if dataSource.neverUpdated {
                    EmptyView()
                        .transition(.opacity)
                } else {
                    
                    TimelineView(.periodic(from: date, by: 1)) { context in
                        
                        List {
                            
                            EventSectionsView(date: context.date, dataSource: dataSource, swipeActionClosure: getSwipeActions)
                                
                    
                        }
                        .animation(.easeInOut(duration: 0.3), value: dataSource.getEventGroups(at: context.date))
                        .listStyle(.elliptical)
                        
                    }
                    
                    
          
                }
                    
            }
            .onAppear {
                dataSource.updates = true
                disappearDate = nil
            }
            .onDisappear {
                dataSource.updates = false
                disappearDate = Date()
            }
        
                
        }
        .tint(Color(UIColor(cgColor: dataSource.filterCalendar!.cgColor)))
        .onAppear() {
            timelineStart = getTimelineStart()
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(dataSource.filterCalendar?.title ?? "")")
        .toolbar(content: {
            
            ToolbarItem(placement: .cancellationAction, content: {
                Button("Done", action: {})
                    .tint(Color(UIColor(cgColor: dataSource.filterCalendar!.cgColor)))
            })
            
            
        })
        
        
            
    }
    
    var date: Date {
        return disappearDate ?? Date()
    }
    

    func getTimelineStart() -> Date {
        
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        comps.second = 0
        return calendar.date(from: comps)!
        
    }
    
    
    func getSwipeActions(event: HLLEvent) -> AnyView {
        
        AnyView(Group {
            
            Button(action: {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation {
                        EventPinningManager.shared.togglePinned(event)
                    }
                }
                    
            }, label: {
                Label("Pin", systemImage: event.isPinned ? "pin.slash.fill" : "pin.fill")
            })
            .tint(Color("PinnedGold"))
            
        })
        
    }
    
}

struct CalendarFilteredEventList_Previews: PreviewProvider {
    static var previews: some View {
        CalendarFilteredEventList(dataSource: .init())
    }
}
