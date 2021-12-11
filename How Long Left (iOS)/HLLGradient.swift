//
//  HLLGradient.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 21/1/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import UIKit

class HLLGradient {
    let colorTop = #colorLiteral(red: 1, green: 0.7437175817, blue: 0.02428589218, alpha: 1).cgColor
    let colorMiddle = #colorLiteral(red: 1, green: 0.5769822296, blue: 0.1623516734, alpha: 1).cgColor
    let colorBottom = #colorLiteral(red: 0.9627912974, green: 0.3692123313, blue: 0, alpha: 1).cgColor
    
    let gl: CAGradientLayer
    
    init() {
        gl = CAGradientLayer()
        gl.colors = [ colorTop, colorBottom]
        gl.locations = [ 0.0, 1.0]
    }
}
