//
//  WelcomeRoutingView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 16/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct WelcomeRoutingView: View {
    
    var source: WelcomeViewPage
    
    var body: some View {
        
       
        getView()
       
        
    }
    
    func getView() -> AnyView {
        
        switch source {
            
        case .welcome:
            break
        case .calendarAccess:
            HLLDefaults.defaults.set(true, forKey: Keys.shownAskCal.rawValue)
        case .selectCals:
            break
        case .extensions:
            break
        }
        
        
        if !HLLDefaults.defaults.bool(forKey: Keys.shownAskCal.rawValue) {
            
            return AnyView(CalendarAccessLoadingView())
            
        } else {
            
            HLLDefaults.defaults.set(true, forKey: Keys.shownAskCal.rawValue)
            
            return AnyView(ExtensionPurchaseParentView(type: .complication))
            
        }
        
    }
    
    enum Keys: String {
        
        case shownIntro = "HLLWelcome_ShownIntro"
        case shownAskCal = "HLLWelcome_ShownAskCalendarAccess"
        case shownChooseCals = "HLLWelcome_ShownChooseCals"
        case showExtensions = "HLLWelcome_ShownExtensions"
        
    }
    
    enum WelcomeViewPage {
        
        case welcome
        case calendarAccess
        case selectCals
        case extensions
        
        
    }
    
    
}

struct WelcomeRoutingView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeRoutingView(source: .selectCals)
    }
}
