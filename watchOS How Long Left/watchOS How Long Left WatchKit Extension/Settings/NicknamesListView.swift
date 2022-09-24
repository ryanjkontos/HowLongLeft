//
//  NicknamesListView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 20/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct NicknamesListView: View {
    
    @ObservedObject var store = NicknameManager.shared
    
    @State var activeObject: NicknameObject?
    
    @State var showDeleteButton = false
    
    @State var createDefault = false
    
    var body: some View {
            
            List {
               
                
                Section(content: {
                    
                    
                    Button(action: {
                    
                    let new = NicknameObject("", nickname: nil, compactNickname: nil)
                        self.activeObject = new
                        
                    }, label: {
                        
                        Text("New Nickname")
                        
                        
                    })
                    
                    ForEach(store.nicknameObjects, content: { object in
                        
                        Button(action:{ activeObject = object }, label:{
                            
                            
                            HStack {
                                
                             
                                
                                VStack(alignment: .leading) {
                                  
                                    
                                    Text(object.nickname ?? "")
                                        .lineLimit(1)
                                        .foregroundColor(.primary)
                            
                                    
                                    Text(object.originalName)
                                        .lineLimit(1)
                                        .foregroundColor(.secondary)
                                    
                                }
                                
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                                
                                
                            })
                        
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                
                                Button(role: .destructive ,action: {
                                    withAnimation {
                                        store.deleteNicknameObject(object)
                                    }
                                    
                                    
                                    
                                }, label: {
                                    
                                    Label(title: {
                                        
                                        Text("Delete Nickname")
                                        
                                    }, icon: {
                                        
                                        Image(systemName: "xmark")
                                        
                                    })
                                    
                                })
                                    .tint(.red)
                                
                            }
                        
                            .id(object.id)
                        
                        
                    })
                        
                    
                  
                        
                    
                }, header: {
                    
                    Text("Nicknames")
                    
                }, footer: { Text("Use nicknames to specify how an event's title should appear in How Long Left. This may be useful if you use a calendar that is read-only.") })
                    
     
            }
        
            .animation(.easeInOut(duration: 0.5), value: store.nicknameObjects)
      
        
            .onAppear() {
                store.loadNicknames()
                
              
                
            }
       
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Nicknames")
            
        
        .sheet(item: $activeObject, onDismiss: nil, content: { obj in
                       
            NavigationView {
                
                NickNameEditorView(obj, store: NicknameManager.shared, presenting: Binding(get: {
                    
                    return activeObject != nil
                    
                }, set: { _ in
                    
                    activeObject = nil
                    
                }))
                    .tint(.orange)
                }
            })
            

    }
    
    @ViewBuilder
    func getGroupActions(for object: NicknameObject, showImages: Bool) -> some View {
        
        Button(role: .destructive, action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation {
                    store.deleteNicknameObject(object)
                }
            }
            
            
        }, label: {
            if showImages {
                Image(systemName: "trash")
            }
            
            Text("Delete")
        })
        
        Button(action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.activeObject = object
            }
            
            
        }, label: {
            if showImages {
                Image(systemName: "slider.horizontal.3")
            }
            
            Text("Edit")
            
        })
            
            .tint(.blue)
        
 
    }

    
}

struct NicknamesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NicknamesListView()
        }
    }
}
