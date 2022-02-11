//
//  HLLEventInfoItem.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 28/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLEventInfoItem: Equatable, Identifiable {
    
    let title: String
    let info: String
    let type: HLLEventInfoItemType
    
    init(_ title: String, _ subtitle: String, _ type: HLLEventInfoItemType) {
        self.title = "\(title):"
        self.info = subtitle
        self.type = type
    }
    
    func combined() -> String {
        return "\(title) \(info)"
    }
    
    static func == (lhs: HLLEventInfoItem, rhs: HLLEventInfoItem) -> Bool {
        return lhs.type == rhs.type
    }
    
}
