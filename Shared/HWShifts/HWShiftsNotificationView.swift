//
//  HWShiftsNotificationView.swift
//  How Long Left
//
//  Created by Ryan Kontos on 4/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct HWShiftsNotificationView: View {
    
    @State var titleText: String
    @State var shifts: [HWShift]
    
    var body: some View {
      
        VStack(spacing: 15) {
            HStack {
                Text(titleText)
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.8)
                Spacer()
            }
            
            VStack(spacing: 14) {
                ForEach(shifts) { shift in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(getRelativeString(for: shift.start).uppercased())
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding(.leading, 13)
                        
                            
                        getCard(shift: shift)
                            .padding(.horizontal, 3)
                            
                       
                    }
                    
                }
            }
            .edgesIgnoringSafeArea(.horizontal)
            
            HStack {
                
                Text("The total duration of these shifts is \(getIntervalString(timeInterval: totalDuration(shifts: shifts))).")
                    .font(.system(size: 15))
                    .fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
                   
                Spacer()
                
            }
            
            .padding(.leading, 10)
            .edgesIgnoringSafeArea(.horizontal)
            
            
        }
        .padding(.top, 15)
        
        .edgesIgnoringSafeArea(.vertical)
        
       
            
        
    }
    
    func getCard(shift: HWShift) -> some View {
        
        
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3.5) {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text(formatDate(date: shift.start))
                        .fontWeight(.medium)
                        .font(.system(size: 16.5))
                    
                    Text("\(shift.start.formattedTime()) - \(shift.end.formattedTime())".lowercased())
                        .font(.system(size: 14.5))
                        .fontWeight(.medium)
                    
                }
                
                Text("\(getIntervalString(timeInterval: shift.duration))".lowercased())
                    .font(.system(size: 13))
                    //.fontWeight(.light)
                        
        
                
                    
            }
            .foregroundColor(.black)
            .opacity(0.61)
            Spacer()
        }
        .padding(.horizontal, 13)
        
        .frame(height: 70)
        .background(content: {
            
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .foregroundColor(Color("HWGreen"))
            
            
        })
        
   
        
    }
    
    func getRelativeString(for date: Date) -> String {
        
        let daysUntil = date.daysUntil()
        if daysUntil < 2 {
            return date.userFriendlyRelativeString()
        }
        
        return "IN \(daysUntil) DAYS"
        
        
    }
    
    func totalDuration(shifts: [HWShift]) -> TimeInterval {
        return shifts.reduce(0) { result, shift in
            return result + shift.duration
        }
    }
    
    func getIntervalString(timeInterval: TimeInterval) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        return formatter.string(from: timeInterval) ?? "Error"
        
    }
    
    func formatDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter.string(from: date)
        
    }
    
}

struct HWShiftsNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
              HWShiftsNotificationView(titleText: "3 New Shifts For Hannah", shifts: [HWShift(start: Date().addingTimeInterval(1000000), end: Date().addingTimeInterval(100000000)), HWShift(start: Date().addingTimeInterval(1000000), end: Date().addingTimeInterval(100000000))])
        }
    }
}
