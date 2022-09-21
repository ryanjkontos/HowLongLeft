//
//  UpcomingCardView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import SwiftUI

struct UpcomingCellRepresentor: UIViewRepresentable, EventViewRepresentor {
    
    func startNicknaming() {
        nicknaming = event
    }
    
    var event: HLLEvent
    var enableContextMenu: Bool = true
    @Binding var nicknaming: HLLEvent?
    var eventSource: EventSourceProtocol?
    
    func makeUIView(context: Context) -> UpcomingCellView {
        UpcomingCellView()
    }

    func updateUIView(_ uiView: UpcomingCellView, context: Context) {
        uiView.delegate = context.coordinator
        uiView.configureForEvent(event: event)
        
        if enableContextMenu {
            uiView.enableContextMenu()
        }
        
    }
    
    func makeCoordinator() -> EventViewCoordinator {
        EventViewCoordinator(self)
    }
    

}

