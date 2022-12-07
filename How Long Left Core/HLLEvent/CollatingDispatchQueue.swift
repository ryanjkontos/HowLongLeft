//
//  CollatingDispatchQueue.swift
//  How Long Left
//
//  Created by Ryan Kontos on 30/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class CollatingQueue {
    
    private let queue: DispatchQueue
    private var executing = false
    private var lastExecution: Date?
    private var latestClosure: (() -> Void)?
    private var waiting = false

    init(label: String) {
        queue = DispatchQueue(label: label)
    }

    func sync(bypassCollation: Bool = false, execute closure: @escaping (() -> Void)) {
        queue.sync {
            
            if bypassCollation {
                execute(closure)
                return
            }
            
            if let lastExecution = lastExecution, lastExecution.timeIntervalSinceNow > -5 {
                latestClosure = closure
                scheduleExecution()
                return
            }
            execute(closure)
        }
    }

    private func scheduleExecution() {
        if waiting { return }
        waiting = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            self.queue.sync {
                self.waiting = false
                self.execute(self.latestClosure)
            }
        }
    }

    private func execute(_ closure: (() -> Void)?) {
        executing = true
        closure?()
        executing = false
        lastExecution = Date()
    }
    
}
