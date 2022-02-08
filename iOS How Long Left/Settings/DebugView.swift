//
//  DebugView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 1/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
//import Communicator

struct DebugView: View {
    var body: some View {
        
        Form {
            
            Button(action: {
                
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
                    
                    print(error)
                    
                }*/
                
               
                
            }, label: {
                
                Text("Sync Content")
                
            })
            
        }
        
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
        
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
