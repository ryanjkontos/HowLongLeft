//
//  EventSourceProtocol.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

protocol EventSourceProtocol {
    
    func update(force: Bool)
    
    var allowUpdates: Bool { get set }
}
