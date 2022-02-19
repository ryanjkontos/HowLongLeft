//
//  NickNameEditorView.swift
//  How Long Left
//
//  Created by Ryan Kontos on 19/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct NickNameEditorView: View {
    
    @State var name = "Data Communications"
    @State var nickname = ""
    @State var shortNickname = ""
    
    var body: some View {
        
        List {
            
            Section("Events Named:") {
                TextField("Event Name", text: $name)
                   
            }
            
            Section(content: {
                TextField("Nickname", text: $nickname)
                TextField("Compact Nickname", text: $shortNickname)

            }, header: { Text("Should Appear in How Long Left As:") }, footer: { Text("If you provide a compact nickname, it may be used in contexts where there is limited room avaliable, such as an Apple Watch Complication.") })
            
            
            
            
        }
        .navigationTitle("Manage Nickname")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct NickNameEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NickNameEditorView()
        }
        
    }
}
