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
    
    var event: HLLEvent
    
    var info: LiveEventInfo
    
    init(event inputEvent: HLLEvent) {
        
        self.info = LiveEventInfo(event: inputEvent, configuration: [.status, .location, .start, .end, .elapsed, .duration, .calendar])
        self.event = inputEvent
        
    }
    
    var body: some View {
        
        
        TimelineView(.periodic(from: Date(), by: .second)) { context in
            
            ScrollView {
                
                HStack {
                    
                    VStack(alignment: .leading) {
                    
                        HStack(spacing: 8) {
                        
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(Color(event.color))
                                .frame(width: 5)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(event.title)")
                                    .font(.system(size: 19, weight: .medium, design: .default))
                                Text("\(event.startDate.formattedTime()) - \(event.endDate.formattedTime())")
                                    
                                    .font(.system(size: 17, weight: .light, design: .default))
                            }
                            
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 12)
                    
                       
                    
                        
                    }
                    
                    
                    Spacer()
                    
                }
                
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        
                        ForEach(info.getInfoItems(at: context.date)) { item in
                            
                            VStack(alignment: .leading, spacing: 2) {
                                
                                Text("\(item.title)")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 15, weight: .light, design: .default))
                                
                                Text("\(item.info)")
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    
                                
                            }

                            
                            
                        }
                        
                        if let loc = EventLocationStore.shared.getLocation(for: event.location) {
                            
                            Divider()
                            
                            NavigationLink(destination: {
                                
                                Map(coordinateRegion: .constant(MKCoordinateRegion(center: loc, latitudinalMeters: 500, longitudinalMeters: 500)), interactionModes: [], showsUserLocation: false, userTrackingMode: .constant(.none), annotationItems: [IdentifiableLocation(coordinate: loc)]) { item in
                                    MapMarker(coordinate: item.coordinate)
                                        
                                    
                                    
                                }
                                
                                
                                
                                
                                
                            }, label: {
                                
                                Map(coordinateRegion: .constant(MKCoordinateRegion(center: loc, latitudinalMeters: 500, longitudinalMeters: 500)), interactionModes: [], showsUserLocation: false, userTrackingMode: .constant(.none), annotationItems: [IdentifiableLocation(coordinate: loc)]) { item in
                                    MapMarker(coordinate: item.coordinate)
                                        
                                    
                                    
                                }
                                
                            })
                            .buttonStyle(.borderless)
                            .frame(height: 75)
                            
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, 10)
                          
                            
                           
                            
                        }
                        
                                            
                    }
                    
                    
                    
                    
                    Spacer()
                    
                }
                
                
                
                
              
                
            }
           // .navigationTitle("Event")
            .padding(.horizontal, 10)
            
            
        }
                
        
    }
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
            NavigationView {
                EventInfoView(event: .previewEvent())
            }
        
    }
}

