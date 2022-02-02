//
//  EventsListView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 31/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventsListView: View {
    
    @ObservedObject var dataSource = EventsListDataSource()
    
    var timelineStart: Date!
    
    @EnvironmentObject var store: Store
   
    @State var showComplicationPopover = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State var disappearDate: Date?
    
    @State var showEventView: String?
    

    @State var showOptions = false
    
    let loadDate = Date()
    
    init() {
        
        timelineStart = getTimelineStart()
        
    }
    
    var body: some View {
    
        Group {
        
        if dataSource.neverUpdated {
            EmptyView()
                .transition(.opacity)
        } else {
            
          timelineList
                .transition(.opacity)
      
  
        }
            
        }
        .onAppear {
            ExtensionDelegate.complicationLaunchDelegate = self
            showOptions = false
            showEventView = nil
            dataSource.updates = true
            disappearDate = nil
        }
        .onDisappear {
            dataSource.updates = false
            disappearDate = Date()
        }

       
        
        
    }

 
    
    var timelineList: some View {
        
        GeometryReader { geometry in

            TimelineView(.periodic(from: date, by: 1)) { context in
                
                List {
                    
                    if let events = dataSource.getEvents(at:  disappearDate ?? context.date) {
                        
                        ForEach(Array(events.enumerated()), id: \.1.persistentIdentifier) { index, event in
                            
                            
                            NavigationLink(tag: event.id, selection: $showEventView, destination: { EventView(event: event, openOnOptions: showOptions) }, label: {
                            
                            getViewFor(event: event, at: index, height: geometry.size.height, live: context.cadence == .live, date: context.date)
                                .drawingGroup()
                            })
                            
                         
                                
                                .id("\(event.id) \(index == 0 && HLLDefaults.watch.largeCell)")
                                .listRowBackground((index == 0 && HLLDefaults.watch.largeCell) ? Color.clear : nil)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                    
                                    Button(action: {
                                        
                                        DispatchQueue.global().asyncAfter(deadline: .now() + 0.21) {
                                            
                                            SelectedEventManager.shared.toggleSelection(for: event)
                                        
                                        }
                                            
                                        }) {
                                            Label("Pin", systemImage: event.isSelected ? "pin.slash.fill" : "pin.fill")
                                        
                                    }
                                        .tint(Color("PinnedGold"))
                                    
                                    Button(action: {
                                        
                                        DispatchQueue.global().asyncAfter(deadline: .now() + 0.21) {
                                        
                                        showOptions = true
                                        showEventView = event.id
                                            
                                        } }) {
                                        
                                        Label("Options", systemImage: "ellipsis.circle")
                                        
                                    }
                                        .tint(.blue)
                                    
                                    
                                   
                                    
                                })
                            
                            
                        /*    if index == 0 {
                            
                            Text("4 Wally's Walk")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                            
                            } */
                                
                            
                        }
                        
                    } else {
                        
                        HStack {
                            Spacer()
                            Text("No Events")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                        
                            .listRowPlatterColor(.clear)
                            .frame(height: geometry.size.height-40)
                        
                    }
                    
                    NavigationLink(destination: { SettingsView()
                            .environmentObject(store)
                    }) {
                    
                    SettingsButtonCard()
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .listItemTint(.orange)
                    
                }
   
                // .listStyle(.e)
  
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("How Long Left")
        
    
        
    }
    
    var date: Date {
        
        get {
            
            if let disappearDate = disappearDate {
                return disappearDate
            }
            
            return Date()
            
        }
        
        
        
    }
    
    @ViewBuilder
    func getViewFor(event: HLLEvent, at listIndex: Int, height: CGFloat, live: Bool, date: Date) -> some View {
        
        if listIndex == 0, HLLDefaults.watch.largeCell {
            MainEventCard(event: event, liveUpdates: true, date: date)
                .padding(.bottom, 10)
                .frame(height: event.isSelected ? height+5 : height-5)
        } else if event.completionStatus(at: date) == .current || HLLDefaults.watch.upcomingMode == .withCountdown {
            CountdownCard(event: event, liveUpdates: true, date: date)
        } else {
            EventCard(event: event, liveUpdates: true)
        }
             
    }
    
    func launchedFromComplication() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            if HLLDefaults.watch.complicationEnabled == false {
                showComplicationPopover = true
            }
            
            
        }
        
        
        
    }
    
    func getTimelineStart() -> Date {
        
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        comps.second = 0
        return calendar.date(from: comps)!
        
    }
    
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView()
    }
}
