//
//  NickNameEditorView.swift
//  How Long Left
//
//  Created by Ryan Kontos on 19/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
#if canImport(Introspect)
import Introspect
#endif

struct NickNameEditorView: View {
    
    @ObservedObject var store: NicknameManager
    
    @Binding var presenting: Bool
    
    @State var name = ""
    @State var nickname = ""
    
    @State var showCantSaveAlert = false
    @State var cantSaveMessage = ""
    
    @State var preExisting: Bool
    
    var nicknameObject: NicknameObject
    
    init(_ object: NicknameObject, store: NicknameManager, presenting: Binding<Bool>) {
        
        self.store = store
        self.nicknameObject = object
        
        name = nicknameObject.originalName
        nickname = nicknameObject.nickname ?? ""
        
        _presenting = presenting
        
        
        preExisting = store.nicknameObjects.contains(where: { $0.originalName == object.originalName })
        
    }
    
    var body: some View {
        
        List {
            
            Section("Events Named:") {
                TextField("Event Name", text: $name)
                #if os(iOS)
                    //.introspectTextField(customize: { $0.becomeFirstResponder() })
                #endif
                
            }
            
            Section(content: {
                TextField("Nickname", text: $nickname)
            }, header: { Text("Should Appear in How Long Left As:")})
            
            if preExisting {
                
                Section {
                    
                    Button(role: .destructive, action: {
                        
                        self.presenting = false
                        
                        DispatchQueue.main.async {
                            store.deleteNicknameObject(nicknameObject)
                        }
                        
                        
                        
                    }, label: {
                        
                        Text("Delete Nickname")
                        
                    })
                    
                }
                
            }
            
        }
        
        #if os(iOS)
        .navigationTitle("Manage Nickname")
        #endif
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            
            ToolbarItem(placement: .cancellationAction) {
                Button(action: { presenting = false }, label: { Text("Cancel") })
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(action: { save() }, label: { Text("Save") })
            }
            
        }
        
        .alert("Invalid Nickname", isPresented: $showCantSaveAlert, actions: {
            
            Button(action: {}, label: { Text("OK") })
            
        }, message: {
            
            Text(cantSaveMessage)
            
        })
        
        .tint(.orange)
        
    
        
        
    }
    
    func save() {
        
        if name.isEmpty || nickname.isEmpty {
            cantSaveMessage = "An event name and a nickname must be provided"
            showCantSaveAlert = true
            return
        }
        
        nicknameObject.originalName = name
        nicknameObject.nickname = nickname
        
        store.saveNicknameObject(nicknameObject)
        
        presenting = false
        
    }
}

/*struct NickNameEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NickNameEditorView()
        }
        
    }
}
*/
