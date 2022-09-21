//
//  CountdownCell.swift
//  UIKit HLL
//
//  Created by Ryan Kontos on 27/7/2022.
//

import UIKit

class CountdownCell: UICollectionViewCell, UIContextMenuInteractionDelegate {
   
    
    static let reuseIdentifier = "label-cell-reuse-identifier"
    
    
    let sub = CountdownCellView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    var event: HLLEvent!
    
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }

    func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? 0.9 : 1.0
            self.transform = self.isHighlighted ?
                CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
                CGAffineTransform.identity
        })
    }
}

extension CountdownCell {
    
    func configureForEvent(event: HLLEvent) {
        self.event = event
        sub.configureForEvent(event: event)
        
    }
    
    func configure() {
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear

        contentView.addSubview(sub)
        
        sub.frame = contentView.bounds
        sub.translatesAutoresizingMaskIntoConstraints = false
        
      
       
        
        sub.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        sub.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        sub.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        sub.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        

        addContextMenu()
        sub.configure()
    }
    

    func addContextMenu() {
        
        let interaction = UIContextMenuInteraction(delegate: self)
        sub.addInteraction(interaction)
        
        
    }
    
    
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggested in
            
            return EventContextMenuGenerator.shared.getContextMenu(for: self.event)
            
            
        }
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        
        let parameters = UIPreviewParameters()
             parameters.backgroundColor = UIColor.clear
             parameters.visiblePath = UIBezierPath(roundedRect: sub.bounds , cornerRadius: 30)
             var targetedPreview: UITargetedPreview? = nil
             targetedPreview = UITargetedPreview(view: sub, parameters: parameters)

             return targetedPreview
        
    }
}

