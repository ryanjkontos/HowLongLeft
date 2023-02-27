//
//  NavigationLazyView.swift
//  watchOS How Long Left
//
//  Created by Ryan Kontos on 23/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
