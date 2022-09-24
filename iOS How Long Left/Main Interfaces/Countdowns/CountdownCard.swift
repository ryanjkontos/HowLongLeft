//
//  CountdownCard.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 5/12/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CountdownCard: View {
    
  //  static var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var event: HLLEvent
    
  
    @State var statusText: String = ""
    
    @State var visible = false
    
    @State var style = CountdownCardAppearance.gradient
    
    @Environment(\.colorScheme) var colorScheme
    

    
    var body: some View {
        
        ZStack {
        
            switch style {
            case .gradient:
                LinearGradient(gradient: event.color.toGradient(0, 10), startPoint: .top, endPoint: .bottom)
            case .transparent:
                Color(uiColor: .systemBackground)
                Color(uiColor: event.color)
                    .opacity(0.65)
            case .flat:
                Color(uiColor: event.color)
            case .plain:
                
                
                
                if colorScheme == .light {
                    Color(uiColor: .systemBackground)
                } else {
                    Color(uiColor: .secondarySystemGroupedBackground)
                }
                
                
            }
            
           
                
                
                HStack(spacing: 15) {
                    
                    
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Text(event.title)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .padding(.trailing, 20)
                                .foregroundColor(getTextColor())
                                .font(.system(size: 25, weight: .medium, design: .default))
                            //   .shadow(radius: 6)
                            
                            Text(getStatusText(date: Date()))
                            
                                .foregroundColor(getTextColor())
                                .font(.system(size: 19, weight: .regular, design: .default))
                            // .shadow(radius: 6)
                            
                        }
                        
                        
                        
                        Text(getCountdown(date: Date()))
                            .foregroundColor(getTextColor())
                            .font(.system(size: 28, weight: .medium, design: .default))
                        //.shadow(radius: 6)
                            .monospacedDigit()
                        
                        
                        
                        
                        
                    }
                    
                    
                    Spacer()
                    
                    
                    
                    VStack {
                        
                        Circle()
                            .stroke(lineWidth: 4.5)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20, alignment: .center)
                        
                            .padding(.trailing, 25)
                            .padding(.top, 10)
                        Spacer()
                        
                    }
                    
                    
                }
                .padding(.vertical, 10)
                .padding(.leading, 25)
                
            
            
        }
        
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
         
        .frame(height: 123)
        //.drawingGroup()
        .onAppear(perform: {
            
          //  style = HLLDefaults.countdownsTab.cardAppearance
            
          //  visible = true
            
            
        })
       // .onDisappear(perform: { visible = false })
   
            
            
             
        
    }
        
        

    
    func getTextColor() -> Color {
        
        if style == .plain && colorScheme == .light {
            return .black
        }
        
        return .white
        
    }
        
    
    func getCountdown(date: Date) -> String {
        
        CountdownStringGenerator.shared.generatePositionalCountdown(event: event, at: date, showSeconds: HLLDefaults.countdownsTab.showSeconds)
        
    }
    
    func getStatusText(date: Date) -> String {
        
        switch event.completionStatus(at: date) {
            
        case .upcoming:
            return "starts in"
        default:
            return "ends in"
        }
        
    }
}

struct NewCountdownCard_Previews: PreviewProvider {
    static var previews: some View {
        CountdownCard(event: .previewEvent())
    }
}
