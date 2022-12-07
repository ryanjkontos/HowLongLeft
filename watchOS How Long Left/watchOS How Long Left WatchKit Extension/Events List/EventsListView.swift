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
    
   
    
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    @State var showComplicationPopover = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State var disappearDate: Date?
    
    @State var showEventView: String?
    
    @State var showSettings = false
    @State var sheetEvent: HLLEvent?
    
    @State var showOptions = false
    
    @State var showMore = false
    
    @State var showMoreCurrent = false
    
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
            
            EventView(event: event, open: $sheetEvent, showToolbar: true)
            
        }
        
        .sheet(isPresented: $showSettings) {
            NavigationView{
            SettingsView(open: $showSettings)
                
            }
        }
        
        .sheet(isPresented: $showMore) {
            NavigationView{
                MoreEventsList(openSheet: $showMore)
            }
        }
        
        .sheet(isPresented: $showMoreCurrent) {
            NavigationView{
                InProgressEventsList(openSheet: $showMoreCurrent)
            }
        }
       
        
        
    }

 
    
    var timelineList: some View {


        TimelineView(.periodic(from: date, by: 0.5)) { context in
                
                getList(at: context.date, live: context.cadence == .live)
                

                
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
    
    func getList(at: Date, live: Bool) -> some View {
        
        List {
            
            if let groups = dataSource.getEventGroups(at:  disappearDate ?? date) {
                
                ForEach(Array(groups.enumerated()), id: \.1.self) { sectionIndex, group in
                    
                    Section(content: {
                        
                        ForEach(Array(group.events.enumerated()), id: \.1.self) { index, event in
                            
                            Button(action: {
                                
                                sheetEvent = event
                                
                            }, label: {
                                
                                getViewFor(event: event, sectionIndex: sectionIndex, at: index, height: WKInterfaceDevice.current().screenBounds.size.height, live: live, date: at)
                                
                                    .drawingGroup()
                                
                                
                            })
                            
                            .listItemTint((index == 0 && sectionIndex == 0 && HLLDefaults.watch.largeCell) ? Color.clear : Color(uiColor: event.color).opacity(0.25))
                            
                            .id("\(event.infoIdentifier) \(event.completionStatus(at: date)) \(index == 0 && HLLDefaults.watch.largeCell) \(HLLDefaults.watch.largeHeaderLocation)")
                            .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                getSwipeActions(event: event)
                            })
                          /*  .listRowBackground(
                                
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill( LinearGradient(gradient: event.color.toGradient(0, 10), startPoint: .top, endPoint: .bottom))
                                
                               .opacity(0.9)
                            )
                            */
                           
                            
                            
                        }
                        
                        
                        if group.status == .current && dataSource.currentIsOverLimit && isLuminanceReduced == false {
                            
                            Button(action: {
                                
                                showMoreCurrent.toggle()
                                
                            }, label: {
                                
                                HStack {
                                    Spacer()
                                    Text("More In-Progress...")
                                    Spacer()
                                }
                                
                            })
                            
                        }
                        
                        if sectionIndex == groups.count-1 && group.status != .current && isLuminanceReduced == false {
                            
                            Button(action: {
                                
                                showMore.toggle()
                                
                            }, label: {
                                
                                HStack {
                                    Spacer()
                                    Text("More Events...")
                                    Spacer()
                                }
                                
                            })
                           
                            
                        }
                        
                        
                    }, header: {
                        
                        if (HLLDefaults.watch.largeCell && sectionIndex == 0) {
                            EmptyView()
                        } else if let title = group.title {
                            Text(title)
                                .padding(.bottom, 1)
                                .foregroundColor(group.title == "Pinned" ? Color("PinnedGold") : nil)
                            
                                .font(Font.system(size: 14, weight: (group.title == "Pinned" ? .semibold : .regular), design: .default))
                               
                        } else {
                            EmptyView()
                        }
                        
                    })
                    
                    
                }
                
                .animation(Animation.easeInOut(duration: 0.5), value: groups)
                
                
               
                
            } else {
                
                
                
                
                HStack {
                    Spacer()
                    Text("No Events")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                
                    .listRowPlatterColor(.clear)
                    .frame(height: WKInterfaceDevice.current().screenBounds.size.height-120)
                
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
    
    @ViewBuilder
    func getViewFor(event: HLLEvent, sectionIndex: Int, at listIndex: Int, height: CGFloat, live: Bool, date: Date) -> some View {
        
        if listIndex == 0, sectionIndex == 0, HLLDefaults.watch.largeCell {
            MainEventCard(event: event, liveUpdates: true, date: date)
                .frame(height: height*CGFloat.watchDyanamic(legacy: 0.83, modern: 0.79))
        } else if event.completionStatus(at: date) == .current || HLLDefaults.watch.upcomingMode == .withCountdown {
            CountdownCard(event: event,date: date)
                
        } else {
            EventCard(event: event, liveUpdates: true, date: date)
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
                sheetEvent = event
                    
                } }) {
                
                Label("Options", systemImage: "ellipsis.circle")
                
            }
                .tint(.blue) */
            
            Button(action: {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.21) {
                    
                    withAnimation {
                        EventPinningManager.shared.togglePinned(event)
                    }
                
                }
                    
                }) {
                    Label("Pin", systemImage: event.isPinned ? "pin.slash.fill" : "pin.fill")
                
            }
                .tint(Color("PinnedGold"))
            
            
           
            
        }
        
    }
    
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView()
            
            .previewAllWatches()
    }
}
