//
//  RepresentedEventView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

/// Provides event context menu functionality for a UIView, and a delegate for communication with hosting UIViewRepresentable class.

class RepesentedEventView: LayerContainerView, UIContextMenuInteractionDelegate {
  
    var event: HLLEvent!
    
    var interaction: UIContextMenuInteraction?
    
    var delegate: EventViewCoordinator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func configure() {
        
    }
    
    func configureForEvent(event: HLLEvent) {
        self.event = event
    }
    
    func enableContextMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
        self.interaction = interaction
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggested in
            
            self.delegate?.representor.eventSource?.allowUpdates = false
            return EventContextMenuGenerator.shared.getContextMenu(for: self.event, delegate: nil)
            
            
        }
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.delegate?.representor.eventSource?.allowUpdates = true
            self.delegate?.updateEventSource()
        }
        
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        // print("Preview")
    }
    

}
