//
//  ForegroundLinearGradient.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 31/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

extension Text {
    public func foregroundLinearGradient(
        colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint) -> some View
    {
        self.overlay {

            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(
                self

            )
        }
    }
}
