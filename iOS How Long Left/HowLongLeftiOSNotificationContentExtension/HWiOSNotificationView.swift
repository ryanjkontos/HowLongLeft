//
//  HWiOSNotificationView.swift
//  HowLongLeftiOSNotificationContentExtension
//
//  Created by Ryan Kontos on 5/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct HWiOSNotificationView: View {
    
    var titleText: String
    
    var bodyText: String
    
    var shifts: [HWShift]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(titleText)
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.8)

                        if let first = shifts.first {
                            Text(first.start.mondayOfWeekString())
                                .foregroundColor(.secondary)
                                //.fontWeight(.semibold)
                                .font(.system(size: 17))
                        } else {
                            Text(bodyText)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }

                if !shifts.isEmpty {
                    VStack(spacing: 17) {
                        ForEach(shifts) { shift in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(getRelativeString(for: shift.start).uppercased())
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)

                                getCard(shift: shift)
                            }
                        }
                    }
                    
                    HStack {
                        
                        Text("The total duration of these shifts is \(getIntervalString(timeInterval: totalDuration(shifts: shifts))).")
                            .font(.system(size: 15))
                            .fontWeight(.regular)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.secondary)
                        Spacer()
                        
                    }
                }
                
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 25)
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    

    
    func getCard(shift: HWShift) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 1.7) {
                Text(formatDate(date: shift.start))
                    .fontWeight(.medium)
                    .font(.system(size: 16.5))

                Text("\(shift.start.formattedTime()) - \(shift.end.formattedTime()) (\(getIntervalString(timeInterval: shift.duration)))".lowercased())
                    .font(.system(size: 14.5))
                
            }
            .foregroundColor(.black)
            .opacity(0.61)
            Spacer()
        }
        .padding(.horizontal, 13)
        .frame(height: 50)
        .background(content: {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .foregroundColor(Color("HWGreen"))
        })
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
    
    func getRelativeString(for date: Date) -> String {
        
        let daysUntil = date.daysUntil()
        if daysUntil < 2 {
            return date.userFriendlyRelativeString()
        }
        
        return "IN \(daysUntil) DAYS"
        
        
    }
    
    func formatDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter.string(from: date)
        
    }
       
}

struct HWiOSNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        HWiOSNotificationView(titleText: "4 New Shifts For Hannah", bodyText: "Body", shifts: [HWShift(start: Date(timeIntervalSince1970: 16070003600), end: Date(timeIntervalSince1970: 16070005400)), HWShift(start: Date(timeIntervalSince1970: 16070005400), end: Date(timeIntervalSince1970: 16070010800)), HWShift(start: Date(timeIntervalSince1970: 16070010800), end: Date(timeIntervalSince1970: 16070014400)), HWShift(start: Date(timeIntervalSince1970: 16070014400), end: Date(timeIntervalSince1970: 16070079200))])
    }
}
