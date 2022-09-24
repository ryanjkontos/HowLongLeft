//
//  ListButtonModifier.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 24/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct ListButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        
        content
            .foregroundColor(.primary)
            .introspectTableViewCell(customize: { cell in
                cell.accessoryType = .disclosureIndicator
            })
            
    }
}

extension View {
    func listButton() -> some View {
        modifier(ListButtonModifier())
    }
}
