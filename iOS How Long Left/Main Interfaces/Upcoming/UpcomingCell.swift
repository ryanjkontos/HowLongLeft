//
//  UpcomingCell.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 27/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import UIKit

class UpcomingCell: UICollectionViewCell, UIContextMenuInteractionDelegate {
   
    
    static let reuseIdentifier = "label-cell-reuse-identifier"
    
    
    let sub = UpcomingCellView()
    
    var menuDelegate: EventContextMenuDelegate?

    var event: HLLEvent!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }

    func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? 0.9 : 1.0
            
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sub.frame = contentView.bounds
    }
}

extension UpcomingCell {
    
    func configureForEvent(event: HLLEvent) {
        
        self.event = event
        sub.configureForEvent(event: event)
        
    }
    
    func configure() {
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear

        sub.frame = contentView.bounds
        contentView.addSubview(sub)
        sub.configure()

        addContextMenu()
        
    }
    
    func addContextMenu() {
        
        let interaction = UIContextMenuInteraction(delegate: self)
        sub.addInteraction(interaction)
        
        
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggested in
            
            return EventContextMenuGenerator.shared.getContextMenu(for: self.event, delegate: self.menuDelegate)
            
            
        }
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        
        let parameters = UIPreviewParameters()
             parameters.backgroundColor = UIColor.clear
             parameters.visiblePath = UIBezierPath(roundedRect: sub.bounds , cornerRadius: 12)
             var targetedPreview: UITargetedPreview? = nil
             targetedPreview = UITargetedPreview(view: sub, parameters: parameters)

             return targetedPreview
        
    }
}

