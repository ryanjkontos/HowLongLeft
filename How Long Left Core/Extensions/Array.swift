//
//  Array.swift
//  How Long Left
//
//  Created by Ryan Kontos on 17/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
}
