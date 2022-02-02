//
//  EventRow.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 22/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


protocol EventRow {
    
    var event: HLLEvent! { get set }
    var rowCompletionStatus: HLLEvent.CompletionStatus! { get set }
    
    func setup(event: HLLEvent)
    func updateRow()
    
}
