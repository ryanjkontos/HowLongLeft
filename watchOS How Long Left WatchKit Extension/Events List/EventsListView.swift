//
//  EventsListView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 31/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WatchKit

struct EventsListView: View {
    
    @ObservedObject var dataSource = EventsListDataSource()
    
    var timelineStart: Date!
    
    @EnvironmentObject var store: Store
   
    @State var showComplicationPopover = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State var disappearDate: Date?
    
    @State var showEventView: String?
    
    @State var showSettings = false
    @State var sheetEvent: HLLEvent?
    
    @State var showOptions = false
    
  //  @State var location = false
 //   @State var bar = false
    
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
   
        .sheet(item: $sheetEvent) { event in
            
            EventView(event: event, openOnOptions: false, open: $sheetEvent)
            
        }
        
        .sheet(isPresented: $showSettings) {
            NavigationView{
            SettingsView(open: $showSettings)
                .environmentObject(store)
            }
        }
       
        
        
    }

 
    
    var timelineList: some View {
        
        GeometryReader { geometry in

            TimelineView(.periodic(from: date, by: 1)) { context in
                
                List {
                    
                    if let events = dataSource.getEvents(at:  disappearDate ?? context.date) {
                        
                        ForEach(Array(events.enumerated()), id: \.1.persistentIdentifier) { index, event in
                            
                            Button(action: {
                                
                                sheetEvent = event
                                
                            }, label: {
                                
                                getViewFor(event: event, at: index, height: WKInterfaceDevice.current().screenBounds.size.height, live: context.cadence == .live, date: context.date)
                                .drawingGroup()
                                
                            })
                            
                                .listRowBackground((index == 0 && HLLDefaults.watch.largeCell) ? Color.clear : nil)
                                .id("\(event.infoIdentifier) \(event.completionStatus(at: context.date)) \(index == 0 && HLLDefaults.watch.largeCell)")
                                .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                    getSwipeActions(event: event)
                                })
                            
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
                    
                    
                    Button(action: {
                        
                        showSettings = true
                        
                    }, label: {
                        
                        
                        SettingsButtonCard()
                            
                    })
                    .listItemTint(.orange)
            
                   
                    
                    /*
                    Toggle(isOn: $bar, label: { Text("Show Bar") })
                    Toggle(isOn: $location, label: { Text("Show Location") }) */
                 
                    
                }
                .listStyle(.plain)

                
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
                .frame(height: height*CGFloat.watchDyanamic(legacy: 0.83, modern: 0.79))
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
    
    func getSwipeActions(event: HLLEvent) -> some View {
        
        Group {
            
       
            
        /*    Button(action: {
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.21) {
                
                showOptions = true
                showEventView = event.id
                    
                } }) {
                
                Label("Options", systemImage: "ellipsis.circle")
                
            }
                .tint(.blue) */
            
            Button(action: {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.21) {
                    
                    withAnimation {
                        SelectedEventManager.shared.toggleSelection(for: event)
                    }
                
                }
                    
                }) {
                    Label("Pin", systemImage: event.isSelected ? "pin.slash.fill" : "pin.fill")
                
            }
                .tint(Color("PinnedGold"))
            
            
           
            
        }
        
    }
    
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView()
            .environmentObject(Store())
            .previewAllWatches()
    }
}
