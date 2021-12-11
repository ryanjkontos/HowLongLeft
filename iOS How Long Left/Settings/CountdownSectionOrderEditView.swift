//
//  CountdownSectionOrderEditView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 5/12/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct CountdownSectionOrderEditView: View {
    
    @EnvironmentObject var settingsObject: CountdownCardSettingsObject
    
    @State var isEditMode: EditMode = .active
    
    var body: some View {
        
        NavigationView {
        
        List {
            
            Section {
                
               
                
            }
            
           
               
            
               
               
            
        }
        .introspectTableView(customize: { table in
            
            table.sectionHeaderHeight = 10
            
        })
        
        .environment(\.editMode, self.$isEditMode)
        .animation(.default, value: settingsObject.showUpcoming)
        .animation(.default, value: settingsObject.showInProgress)
        .navigationTitle("Section Order")
        .navigationBarTitleDisplayMode(.large)
            
        }
        
    }
    
    func move(from source: IndexSet, to destination: Int) {
        settingsObject.sectionOrder.move(fromOffsets: source, toOffset: destination)
    }
}

struct CountdownSectionOrderEditView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownSectionOrderEditView()
    }
}
