//
//  Countdown.swift
//  Watch App Extension
//
//  Created by Ryan Kontos on 24/10/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct Countdown: View {
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var value: String = "00:00"
    let gen = CountdownStringGenerator()
    
    var event: HLLEvent
    
    
    var body: some View {
        Text(value)
            .onAppear() {
                value = gen.generatePositionalCountdown(event: self.event)
            }
            .onReceive(timer) { _ in
                
                DispatchQueue.global(qos: .userInteractive).async {
                    let text = gen.generatePositionalCountdown(event: self.event)
                    
                    DispatchQueue.main.async {
                        value = text
                    }
                    
                }
                
           
            }
    }
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        Countdown(event: .previewEvent())
    }
}
