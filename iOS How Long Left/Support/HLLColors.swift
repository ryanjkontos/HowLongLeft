//
//  HLLColors.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 7/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

struct HLLColors {
    
    #if targetEnvironment(macCatalyst)
    
    
  //  static var backgroundColor = UIColor.systemGroupedBackground
  //  static var groupedCell = UIColor.secondarySystemGroupedBackground
    
    
    #else
    
   // static var backgroundColor = UIColor(.systemGroupedBackground, dark: .secondarySystemGroupedBackground)
   // static var groupedCell = UIColor(.systemBackground, dark: .tertiarySystemGroupedBackground)
    
    
    #endif
    
}
