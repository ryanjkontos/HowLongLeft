//
//  NicknamingViewObject.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

class NicknamingViewObject: ObservableObject {
    
    static var shared = NicknamingViewObject()
    
    @Published var nicknamingEvent: HLLEvent?
    
}
