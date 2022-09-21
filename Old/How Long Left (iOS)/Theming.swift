//
//  Theming.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 20/4/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import UIKit
import DeviceKit

class AppTheme {
    
    static var current: HLLTheme {
        
        get {
        
        if HLLDefaults.defaults.bool(forKey: "useDarkTheme") == true {
            
            return HLLDarkTheme()
            
        } else {
            
            return HLLDefaultTheme()
            
        }
            
        }
        
        
    }
    
    
    
}


class HLLDefaultTheme: HLLTheme {
    
    var statusBarStyle: UIStatusBarStyle = .default
    
    var plainColor: UIColor = .white
    
    var groupedTableViewBackgroundColor: UIColor = .groupTableViewBackground
    
    var barStyle: UIBarStyle = .default
    
    var translucentBars: Bool = true
    
    var tableCellSeperatorColor: UIColor = .gray
    
    var tableCellBackgroundColor: UIColor = .white
    
    var textColor: UIColor = .black
    
    var secondaryTextColor: UIColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
    
    var selectedCellView: UIView? {
        
        get {
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = #colorLiteral(red: 0.7452212881, green: 0.7452212881, blue: 0.7452212881, alpha: 0.7228970462)
            return bgColorView
            
        }
        
    }
}

class HLLDarkTheme: HLLTheme {

    
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    var plainColor: UIColor = .black
    
    var groupedTableViewBackgroundColor: UIColor = .black
    
    var barStyle: UIBarStyle = .black
    
    var translucentBars: Bool = false
    
    var tableCellSeperatorColor: UIColor = #colorLiteral(red: 0.2406989932, green: 0.2407459915, blue: 0.2543286979, alpha: 0.9171393408)
    
    var tableCellBackgroundColor = #colorLiteral(red: 0.109605588, green: 0.1096317843, blue: 0.1174220815, alpha: 1)
    
    var textColor: UIColor = .white
    
    var secondaryTextColor: UIColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
    
    var selectedCellView: UIView? {
        
        get {
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = #colorLiteral(red: 0.1670962881, green: 0.1670962881, blue: 0.1670962881, alpha: 1)
            return bgColorView
            
        }
        
    }
    
}

protocol HLLTheme {
    
    var groupedTableViewBackgroundColor: UIColor { get }
    
    var plainColor: UIColor { get }
    
    var barStyle: UIBarStyle { get }
    
    var translucentBars: Bool { get }
    
    var tableCellSeperatorColor: UIColor { get }
    
    var tableCellBackgroundColor: UIColor { get }
    
    var textColor: UIColor { get }
    
    var secondaryTextColor: UIColor { get }
    
    var selectedCellView: UIView? { get }
    
    var statusBarStyle: UIStatusBarStyle { get }
    
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
