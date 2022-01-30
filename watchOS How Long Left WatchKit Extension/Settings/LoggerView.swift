//
//  LoggerView.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 29/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct LoggerView: View {
    
    @State var logs = ComplicationLogger.getLogItems()
    
    var body: some View {
        
        List {
            
            ForEach(logs) { log in
                
                VStack(alignment: .leading) {
                    
                    Text(log.message)
                        .font(.body)
                    Text("\(log.date.formattedDate()), \(log.date.formattedTime(seconds: true))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                }
                
            }
            
        }.onAppear() {
            logs = ComplicationLogger.getLogItems()
        }
        
    }
}

struct LoggerView_Previews: PreviewProvider {
    static var previews: some View {
        LoggerView()
    }
}
