//
//  DebugView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 1/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import BackgroundTasks
//import Communicator

struct DebugView: View {


    init() {
        
        let array = HLLDefaults.defaults.stringArray(forKey: "WidgetUpdates") ?? [String]()
        widgetUpdates = array.map({ Date(timeIntervalSinceReferenceDate: TimeInterval(String($0))!) })
        
        
    }
    
    @State var widgetUpdates: [Date]
    
    var body: some View {
        
        Form {
            
         /*   Button(action: {
                
               // let message = ImmediateMessage(identifier: "immediateMessage", content: ["messageKey": true])
               // Communicator.shared.send(message)
                
            }, label: {
                
                Text("Send Immediate Message")
                
            })
            
            Button(action: {
                
               // let message = GuaranteedMessage(identifier: "guaranteedMessage", content: ["messageKey": true])
               // Communicator.shared.send(message)
                
            }, label: {
                
                Text("Send Guaranteed Message")
                
            })
            
            Button(action: {
                
         
               /* let data: Content = ["ComplicationPurchased": true]
                
                do {
                    
                   try Communicator.shared.sync(Context(content: data))
                    
                } catch {
                    
                    // print(error)
                    
                }*/
                
               
                
            }, label: {
                
                Text("Sync Content")
                
            }) */
            
            Section(content: {
                
      
                
                HStack {
                    Text("Background Refreshes")
                    Spacer()
                    Text(String(HLLDefaults.defaults.integer(forKey: "BGCount")))
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    
                    HStack {
                        Text("Background Widget Updates")
                        Spacer()
                        Text(String(HLLDefaults.defaults.integer(forKey: "BGCausedWidgetUpdateCount")))
                            .foregroundColor(.secondary)
                    }
                    
                }
                
            }, header: { Text("Background Tasks") })
            
            
            Section {
                
                NavigationLink(destination: { widgetUpdateList }) {
                    
                    Text("Widget Updates")
                    
                }
                
                
            }
            
        }
 
        .navigationTitle("Debug")
        
   
        
    }
    

   
    
    var widgetUpdateList: some View {
        
        
        List {
            
            ForEach(widgetUpdates.indices.reversed(), id: \.self, content: { index in
                
                let date = widgetUpdates[index]
                
                VStack(alignment: .leading) {
                    
                    Text("Update #\(index+1)")
                        .font(.system(size: 18, weight: .bold, design: .default))
                    
                    Text("\(date.formattedDate()), \(date.formattedTime())")
                        .foregroundColor(.secondary)
                    
                }
                .padding(.vertical, 5)
                
                
                
                
            })
            
            
        }
        .navigationTitle("Widget Updates")
        .toolbar(content: {
            
            ToolbarItem(placement: .navigationBarTrailing, content: {
                
                Button(action: {
                    
                    DispatchQueue.main.async {
                        
                        
                        withAnimation {
                            
                            HLLDefaults.defaults.set([String](), forKey: "WidgetUpdates")
                        
                        let array = HLLDefaults.defaults.stringArray(forKey: "WidgetUpdates") ?? [String]()
                        widgetUpdates = array.map({ Date(timeIntervalSinceReferenceDate: TimeInterval(String($0))!) })
                            
                        }
                    }
                    
                   
                    
                }, label: {
                    
                    Text("Delete All")
                    
                })
                
            })
            
        })
        
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
