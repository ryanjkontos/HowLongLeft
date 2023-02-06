//
//  EventsListView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 31/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WatchKit
import EventKit
import Combine

struct EventsListView: View {
    
    let detector: CurrentValueSubject<CGFloat, Never>
        let publisher: AnyPublisher<CGFloat, Never>
    
    @ObservedObject var dataSource = EventsListDataSource()
    
    var timelineStart: Date!
    
    @State var debounce_timer: Timer?
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State var disappearDate: Date?
    
    @State var showSettings = false
    
    @State var showFloatingSettingsButton = true
    
    @State var hasHiddenButton = false
    
    @State var filterCalendar: EKCalendar?
    
    @State var loadDate = Date()
    
    init() {
        
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.publisher = detector
            .dropFirst()
            .eraseToAnyPublisher()
        self.detector = detector
        timelineStart = getTimelineStart()
        
    }
    
    var body: some View {
    
        ZStack {
            Group {
                if dataSource.neverUpdated {
                    EmptyView()
                        .transition(.opacity)
                } else {
                    
                    TimelineView(.periodic(from: date, by: 1)) { context in
                        
                        List {
                            
                            Group {
                                
                                EventSectionsView(date: context.date, dataSource: dataSource, swipeActionClosure: getSwipeActions)
                                
                                Button(action: { showSettings = true }) {
                                    SettingsButtonCard()
                                }
                                .listItemTint(.orange)
                                
                            }
                          
                        }
                        .animation(.easeInOut(duration: 0.3), value: dataSource.getEventGroups(at: context.date))
                        .listStyle(.elliptical)
                        
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarTitle("How Long Left")
                    .transition(.opacity)
                    
                }
                
            }
            .onAppear {
                loadDate = Date()
                ExtensionDelegate.complicationLaunchDelegate = self
                dataSource.updates = true
                disappearDate = nil
            }
            .onDisappear {
                dataSource.updates = false
                disappearDate = Date()
            }
            .sheet(isPresented: $showSettings) {
                NavigationView{
                    SettingsView(open: $showSettings)
                }
            }
            .sheet(item: $filterCalendar, content: { cal in
                CalendarFilteredEventList(dataSource: EventsListDataSource(filterCalendar: cal))
            })
           
            
        }
        .onAppear() {
            loadDate = Date()
        }
            
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
            
            Button(action: {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    filterCalendar = event.calendar
                }
                    
            }, label: {
                Label("Filter", systemImage: "calendar.day.timeline.trailing")
            })
            .tint(Color.red)
            
        })
        
    }
        
    
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView()
            .previewAllWatches()
    }
}

extension EKCalendar: Identifiable {
    
    public var id: String {
        return self.calendarIdentifier
    }
    
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
