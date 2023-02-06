//
//  RepeatingTimer.swift
//  How Long Left
//
//  Created by Ryan Kontos on 26/11/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class RepeatingTimer {
    let timeInterval: TimeInterval
    init(time: Double) {
       
        self.timeInterval = TimeInterval(time)
        
    }
    private lazy var timer: DispatchSourceTimer = {
        
        let queue = DispatchQueue(label: "HLLRepeatingTimer", qos: .default)
        let t = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        t.schedule(deadline: .now(), repeating: self.timeInterval, leeway: .nanoseconds(0))
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    var eventHandler: (() -> Void)?
     enum State {
        case suspended
        case resumed
    }
    var state: State = .suspended
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
