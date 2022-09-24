//
//  CountdownsViewRepesentor.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 23/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CountdownsViewRepesentor: UIViewControllerRepresentable {
 
    
    typealias UIViewControllerType = UINavigationController
    
   
    func makeUIViewController(context: Context) -> UIViewControllerType {
        return HLLNavigationController(rootViewController: CountdownsViewController())
    }
    

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
   /* func makeCoordinator() -> EventViewCoordinator {
        EventViewCoordinator(self)
    } */
    
}


