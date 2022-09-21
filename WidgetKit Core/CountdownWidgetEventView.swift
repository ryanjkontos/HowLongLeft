//
//  CountdownWidgetEventView.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 16/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WidgetKit


struct CountdownWidgetEventView: View {
    
    var event: EventUIObject
    var displayDate: Date
    var barFraction: Double = 0.00
    
    var barEnabled: Bool
    
    @Environment(\.colorScheme) var systemColorScheme: ColorScheme
    
    var colorScheme: ColorScheme {
        
        if HLLDefaults.widget.theme == .system {
            return systemColorScheme
        }
        
        if HLLDefaults.widget.theme == .dark {
            return .dark
        }
        
        return .light
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 1) {
                        
               
                            
                        Text(event.title)
                            //.foregroundColor(.black)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(Font.system(size: 23, weight: .semibold, design: .default))
                    
                        }
                        .minimumScaleFactor(0.8)
                    
                        Text("\(event.countdownTypeString(at: displayDate))")
                        .foregroundColor(Color(.systemGray))
                        .font(Font.system(size: 16, weight: .medium, design: .default))
                }
            
            Spacer()
     
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(event.countdownDate(at: displayDate), style: .timer)
                        .font(Font.system(size: 27, weight: .bold, design: .default).monospacedDigit())
                            .foregroundColor(tintCol)
                            .minimumScaleFactor(0.3)
                            .lineLimit(1)
                            .brightness(-0.05)
                            
                    if showBar, HLLDefaults.widget.showProgressBar {
                        ProgressBar(percent: Double(percent), color: tintCol)
                        
                            .frame(height:9)
                    }
                   
                }
            
           

        }.colorScheme(colorScheme)
            .padding(.vertical, 16)
        
        
            
    }
    
    var tintCol: Color {
        
        if HLLDefaults.widget.tintCalendarColour {
            return Color(event.color)
        } else {
            return .HLLOrange
        }
        
    }
    
    var showBar: Bool {
        
        get {
            
            if !barEnabled {
                return false
            }
            
            if event.completionStatus(at: displayDate) == .current {
                return true
            }
            
            return false
            
            
        }
        
        
    }
    
    var percent: Int {
        
        get {
            
            let value = PercentageCalculator().calculateIntPercentDone(of: event, at: displayDate)
  
            

            
            return value
            
        }
        
    }
    
    var countdownDate: Date {
        
        get {
            
            
            let status = event.completionStatus(at: displayDate)
            
            if status == .upcoming {
                return event.startDate
            }
            
            return event.endDate
            
        }
        
    }
    
    var spacing: CGFloat {
        
        get {
            
            if showBar {
                
                return 35
                
            }
            
            return 41
            
        }
        
        
    }
    
    var barProgressDivisor: Double {
    
        
        if percent == 0 {
            return 0
        }
        
      
        print("Percent is \(percent)")
        
        let value = Double(100)/Double(percent)
        
        print("Returning divisor \(value)")
        
        return value
    }
    

    
    
}

struct CountdownWidgetEventView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownWidgetEventView(event: PreviewEvent.inProgressPreviewEvent(), displayDate: Date(), barEnabled: true)
            .padding(.horizontal, 20)
            .modifier(HLLWidgetBackground())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
         
    }
}
