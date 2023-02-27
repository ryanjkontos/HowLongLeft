//
//  EventSectionsView.swift
//  How Long Left watch App WatchKit Extension
//
//  Created by Ryan Kontos on 19/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WatchKit


struct EventSectionsView: View {
    

    var date: Date
    @State var sheetEvent: HLLEvent?
    @State var showMore = false
    @State var showMoreCurrent = false
    
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    
    var dataSource: EventsListDataSource
    
    @State var refDate = Date()
    
    var swipeActionClosure: ((HLLEvent) -> (AnyView))?
    
    var body: some View {

            
            if let groups = dataSource.getEventGroups(at: date) {
                
                ForEach(Array(groups.enumerated()), id: \.1.self) { sectionIndex, group in
                    Section(content: {
                        ForEach(Array(group.events.enumerated()), id: \.1.self) { index, event in
                          Button(action: {
                            sheetEvent = event
                          }, label: {
                            getCardFor(event: event, sectionIndex: sectionIndex, at: index, height: WKInterfaceDevice.current().screenBounds.size.height, live: true, date: date)
                              .drawingGroup()
                             
                          })
                      
                          .listRowBackground(ZStack {
                            GeometryReader { proxy in
                              if index == 0 && sectionIndex == 0 && HLLDefaults.watch.largeCell {
                                Color.clear
                              } else {
                                Color(event.color).opacity(0.23)
                                if event.completionStatus(at: date) == .current {
                                  Color(event.color).opacity(0.3)
                                    .frame(width: proxy.size.width * PercentageCalculator.completionValue(for: event, at: date))
                                }
                              }
                            }
                          }.cornerRadius(12))
                          .drawingGroup()
                          .id("\(event.infoIdentifier) \(event.completionStatus(at: date)) \(index == 0 && HLLDefaults.watch.largeCell) \(HLLDefaults.watch.largeHeaderLocation)")
                          .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                              
                              if let actions = swipeActionClosure?(event) {
                                actions
                              }

                          })
                         
                        }
                        
                        if group.status == .current && dataSource.currentIsOverLimit && !isLuminanceReduced {
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
                        if sectionIndex == groups.count - 1 && group.status != .current && !isLuminanceReduced {
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
                        if let title = group.title {
                            Text(title)
                                .fontWeight(.medium)
                                .textCase(.none)
                                .headerProminence(.increased)
                                .foregroundColor(.white)
                                .listRowPlatterColor(.clear)
                                .padding(.bottom, 0.5)
                        }
                    })
                   
                   
                }

                
                .animation(Animation.easeInOut(duration: 0.5), value: groups)
                
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
                .sheet(item: $sheetEvent) { event in
                    
                    EventView(event: event, open: $sheetEvent, showToolbar: true)
                    
                }
                
                
                
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
            
        
    }
    

    @ViewBuilder func getCardFor(event: HLLEvent, sectionIndex: Int, at listIndex: Int, height: CGFloat, live: Bool, date: Date) -> some View {
        
        if listIndex == 0, sectionIndex == 0, HLLDefaults.watch.largeCell {
            MainEventCard(event: event, liveUpdates: true, date: date)
                .frame(height: height*CGFloat.watchDyanamic(legacy: 0.83, modern: 0.79))
        } else if event.completionStatus(at: date) == .upcoming {
            if HLLDefaults.watch.largeUpcomingCard {
                CountdownCard(event: event,date: date, referenceDate: $refDate)
            } else {
                EventCard(event: event, liveUpdates: true, date: date, referenceDate: $refDate)
            }
           
                
        } else {
            if HLLDefaults.watch.largeCurrentCard {
                CountdownCard(event: event,date: date, referenceDate: $refDate)
            } else {
                EventCard(event: event, liveUpdates: true, date: date, referenceDate: $refDate)
            }
           
        }
             
    }
    

}

struct EventSectionsView_Previews: PreviewProvider {
    static var previews: some View {
        EventSectionsView(date: Date(), dataSource: EventsListDataSource())
    }
}
