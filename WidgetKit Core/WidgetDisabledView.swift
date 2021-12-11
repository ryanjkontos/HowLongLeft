//
//  WidgetDisabledView.swift
//  How Long Left
//
//  Created by Ryan Kontos on 2/12/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WidgetKit

struct WidgetDisabledView: View {
    
    var reason: WidgetDisabledReason
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        Text(reasonString)
            .foregroundColor(col)
            .multilineTextAlignment(.center)
            .font(.system(size: 18, weight: .semibold, design: .default))
            .padding(.horizontal, 18)
    }
    
    var reasonString: String {
        
        switch reason {
        
        case .noCalAccess:
            return "No Calendar Access"
        case .notPurchased:
            return "Widgets require How Long Left Pro"
        case .notMigrated:
            return "Launch the How Long Left app to enable Widgets"
        }
        
    }
    
    var col: Color {
        
        if colorScheme == .dark {
            return .white
        } else {
            return .HLLOrange
        }
        
    }
    
}

struct WidgetDisabledView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetDisabledView(reason: .noCalAccess)
            .modifier(HLLWidgetBackground())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            
    }
}

enum WidgetDisabledReason {
    
    case noCalAccess
    case notPurchased
    case notMigrated
    
}
