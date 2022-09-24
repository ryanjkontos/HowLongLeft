//
//  IconButtonTableViewCell.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 28/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class IconButtonTableViewCell: UITableViewCell {

    struct Configuration {
        var name: String
        var imageName: String
        var imageColor: UIColor
        var iconBackground: UIColor
    }
    
    private let symbolBackgroundView = UIView()
    private let symbolView = UIImageView()
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        load()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(using config: Configuration) {
        
        let image = UIImage(systemName: config.imageName)
        
        symbolView.image = image
        symbolBackgroundView.backgroundColor = config.iconBackground
        label.text = config.name
        
        let symbolConfig = UIImage.SymbolConfiguration(paletteColors: [config.imageColor])
        symbolView.preferredSymbolConfiguration = symbolConfig
    }
    
    private func load() {
        
        
        self.accessoryType = .disclosureIndicator
        
        contentView.addSubview(symbolBackgroundView)
        
        
        symbolBackgroundView.layer.cornerCurve = .continuous
        symbolBackgroundView.layer.cornerRadius = 6
        symbolBackgroundView.layer.masksToBounds = true
        
        symbolBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            symbolBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            symbolBackgroundView.heightAnchor.constraint(equalToConstant: 26),
            symbolBackgroundView.widthAnchor.constraint(equalToConstant: 26),
            symbolBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        
        ])
        
       
        symbolView.translatesAutoresizingMaskIntoConstraints = false
        symbolView.contentMode = .scaleAspectFit
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        symbolBackgroundView.addSubview(symbolView)
        
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
        
            symbolView.centerYAnchor.constraint(equalTo: symbolBackgroundView.centerYAnchor),
            symbolView.centerXAnchor.constraint(equalTo: symbolBackgroundView.centerXAnchor),
            symbolView.widthAnchor.constraint(equalToConstant: 20),
            symbolView.heightAnchor.constraint(equalTo: symbolView.widthAnchor),
            
            label.leadingAnchor.constraint(equalTo: symbolBackgroundView.trailingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
        
        
       
        
        
    }

}
