//
//  CountdownCardRepresentableView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import SwiftUI

struct CountdownCardRepresentor: UIViewRepresentable {
    
    typealias UIViewType = CountdownCellView
    
    var event: HLLEvent
    var enableContextMenu: Bool = true
    @Binding var nicknaming: HLLEvent?
    var eventSource: EventSourceProtocol?
    
    func makeUIView(context: Context) -> UIViewType {
        let uiView = UIViewType()
        uiView.delegate = context.coordinator
        uiView.configureForEvent(event: event)
        
        if enableContextMenu {
            uiView.enableContextMenu()
        }
        
        return uiView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
       
        
    }
    
    func makeCoordinator() -> EventViewCoordinator {
        EventViewCoordinator(self)
    }
    
}

extension CountdownCardRepresentor: EventViewRepresentor {
    
    func startNicknaming() {
        nicknaming = event
    }
    
}
