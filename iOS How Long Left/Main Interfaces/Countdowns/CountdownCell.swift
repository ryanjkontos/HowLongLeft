//
//  CountdownCell.swift
//  UIKit HLL
//
//  Created by Ryan Kontos on 27/7/2022.
//

import UIKit

class CountdownCell: UICollectionViewCell, UIContextMenuInteractionDelegate {
   
    
    static let reuseIdentifier = "hllios.countdowncell"
    
    
    let sub = CountdownCellView()
    
    var menuDelegate: EventContextMenuDelegate?
    
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
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? 0.9 : 1.0
        })
    }
}

extension CountdownCell {
    
    func configureForEvent(event: HLLEvent) {
        self.event = event
        sub.configureForEvent(event: event)
        contentView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func configure() {
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear

        contentView.addSubview(sub)
        
        sub.frame = contentView.bounds
        sub.translatesAutoresizingMaskIntoConstraints = false
        
       
        NSLayoutConstraint.activate([
        
            sub.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            sub.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            sub.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sub.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sub.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            sub.widthAnchor.constraint(equalTo: contentView.subviews.first!.widthAnchor)
        
        ])
      
       /* contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        //contentView.layer.shadowColor = event?.color.cgColor ?? UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.4
       // contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.layer.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 1, height: 1)).cgPath
        contentView.layer.shadowRadius = 8
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
        layer.masksToBounds = true
        */
  
        //self.backgroundColor = .red

        addContextMenu()
        sub.configure()
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
             parameters.visiblePath = UIBezierPath(roundedRect: sub.bounds , cornerRadius: 25)
             var targetedPreview: UITargetedPreview? = nil
             targetedPreview = UITargetedPreview(view: sub, parameters: parameters)

             return targetedPreview
        
    }
}

