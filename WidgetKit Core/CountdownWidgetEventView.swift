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
    
    var event: HLLEvent
    var displayDate: Date
    var barFraction: Double = 0.00
    
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
        

        VStack(alignment: .leading, spacing: spacing) {
                    
            Spacer()
            
                    VStack(alignment: .leading, spacing: 0) {
                    
                        HStack(spacing: 1) {
                        
                if event.isSelected, HLLDefaults.widget.showSelected {
                            
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold, design: .default))
                                
                }
                            
                    
                Text(event.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(Color(.textColor))
                    .font(Font.system(size: 20, weight: .semibold, design: .default))
                    
                        }
                    .minimumScaleFactor(0.8)
                Text("\(countdownText) in")
                    .foregroundColor(Color(.systemGray))
                    .font(Font.system(size: 15, weight: .semibold, design: .default))
                    
                    
                    
                }
            
     
                
            VStack(spacing: 9) {
                
                Text(event.countdownDate(at: displayDate), style: .timer)
                    .font(Font.system(size: 28, weight: .bold, design: .default).monospacedDigit())
                        .foregroundColor(tintCol)
                        //.shadow(radius: 0.1)
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                        .brightness(-0.05)
                        
                 
                    
                if showBar, HLLDefaults.widget.showProgressBar {
                
                    ProgressBar(percent: Double(percent), color: tintCol)
                        .frame(height:9)
                        //.shadow(radius: 0.1)
                    
                }
               
            }
            
            Spacer()

        }.colorScheme(colorScheme)
        
        
            
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
            
        
            
            if event.completionStatus(at: displayDate) == .current {
                return true
            }
            
            return false
            
            
        }
        
        
    }
    
    var percent: Int {
        
        get {
            
            let value = event.calc.calculateIntPercentDone(of: event, at: displayDate)
  
            
            print("Got percent value: \(value) for display date \(displayDate.formattedTime())")
            
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
    
    var countdownText: String {
        
        get {
            
            let status = event.completionStatus(at: displayDate)
            
            if status == .upcoming {
                return event.countdownStringStart
            }
            
            return event.countdownStringEnd
        }
        
    }
    
    
}

struct CountdownWidgetEventView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownWidgetEventView(event: .previewEvent(), displayDate: Date())
            .padding(.horizontal, 20)
            .modifier(HLLWidgetBackground())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
         
    }
}
