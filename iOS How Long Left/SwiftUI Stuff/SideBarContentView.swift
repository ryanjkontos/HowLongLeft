//
//  SideBarContentView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 4/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect
/*
struct SideBarContentView: View {
    
    enum FocusType: Int, Hashable {
        
        case sidebar, none
    }
    
    @Binding var eventViewEvent: HLLEvent?
    
    @EnvironmentObject var selectedTabManager: SelectedTabManager
    
    
    @State var selected: HLLAppTab? {
        
        didSet {
            
            if selectedTabManager.selectedTab != selected {
                selectedTabManager.selectedTab = selected
            }
            
        }
        
    }
    
    var body: some View {
        
        NavigationView {
            
           
            
            SettingsView()
            
        }
        
   
        .onReceive(selectedTabManager.objectWillChange, perform: { value in
            
            if selected != selectedTabManager.selectedTab {
                selected = selectedTabManager.selectedTab
            }
            
            
            
        })
        .onAppear {
                print("Setting selected")
                selected = selectedTabManager.selectedTab
            

        }
        
    }
}


struct SideBarContentView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarContentView(eventViewEvent: .constant(nil))
    }
}
*/
