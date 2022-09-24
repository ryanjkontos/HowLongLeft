//
//  NotificationProfileEditView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 13/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct NotificationProfileEditView: View {
    
    @ObservedObject var store = NotificationGroupStore()
    
    @State var activeGroupID: String?
    
    @Binding var viewController: UINavigationController!
    
    @State var navigationController: UINavigationController?
    
    @State var showDeleteButton = false
    
    @State var createDefault = false
    
    var body: some View {
            
            List {
                
                Section(content: {
                    
                    NavigationLink(destination: { NotificationGroupEditorView(group: store.defaultGroup, store: store, showingBinding: $activeGroupID, createDefault: $createDefault)
                        .environmentObject(store) }, label: {
                        
                        Text("Default Configuration")
                        .foregroundColor(Color.primary) })
                    
                    
                }, footer: { Text("This configuration will automatically be applied to all events by default.") })
                
                Section(content: {
                    
                    ForEach(store.namedGroups, content: { group in
                        
                        NavigationLink(tag: group.id , selection: $activeGroupID, destination: { NotificationGroupEditorView(group: group, store: store, showingBinding: $activeGroupID, createDefault: $createDefault)
                            .environmentObject(store) }, label: {
                            
                                
                                
                            Text(group.name ?? "")
                                .foregroundColor(.primary)
                                
                                
                            })
                           
                            .contextMenu(menuItems: {
                                getGroupActions(for: group, showImages: true)
                            })
                            .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                getGroupActions(for: group, showImages: true)
                            })
                            .id(group.id)
                        
                        
                    })

                    Button(action: { showNameNewConfigPrompt(useDefault: false) }, label: {
                        
                        Text("New Reusable Configuration")
                        
                            .contextMenu(menuItems: {
                                
                                if store.namedGroups.isEmpty == false {
                                    
                                    Button(role: .destructive, action: {
                                       
                                        
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                
                                                withAnimation {
                                                    store.namedGroups.forEach({ store.deleteGroup($0) })
                                                }
                                                
                                                
                                            }
                                            
                                        
                                        
                                       
                                       
                                   }, label: {
                                       Image(systemName: "trash")
                                       Text("Delete All Reusable Configurations") })
                                    
                                }
                                
                                
                            })
                            .id(UUID())
                        
                    })
                        
                    
                        
                        
                    
                    
                }, header: {
                    
                    Text("Reusable Configurations")
                    
                }, footer: {
                    
                    Text("Reusable configurations can created and applied to any number of calendars and individual events.")
                    
                })
                    
                
            }
           
            .onAppear() {
                store.loadGroups()
                
                DispatchQueue.main.async {
                    
                    if createDefault {
                        
                        createDefault = false
                        showNameNewConfigPrompt(useDefault: true)
                        
                    }
                    
                }
                
            }
       
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Notifications")
            

            

    }
    
    @ViewBuilder
    func getGroupActions(for group: NotificationGroup, showImages: Bool) -> some View {
        
        Button(role: .destructive, action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation {
                    store.deleteGroup(group)
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
                self.activeGroupID = group.id
            }
            
            
        }, label: {
            if showImages {
                Image(systemName: "slider.horizontal.3")
            }
            
            Text("Edit")
            
        })
            
            .tint(.blue)
        
 
    }
    
    func showNameNewConfigPrompt(useDefault: Bool) {
        
        var config = AlertConfiguration(showTextField: true, title: "New Reusable Configuration", message: "", prefill: getNewGroupName() ,action: { value in
            
            if let value = value {
                
                if !value.isEmpty {
                
                    
                    
                var new = NotificationGroup.newNamedGroup()
                new.name = value
                    
                    if useDefault {
                        new.triggers = store.defaultGroup.triggers
                        new.startTrigger = store.defaultGroup.startTrigger
                        new.endTrigger = store.defaultGroup.endTrigger
                    }
                    
                    withAnimation {
                        
                        store.saveGroup(new)
                            
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                                activeGroupID = new.id
                            }
                    }
                    
                    return
                    
                
                    
                } else {
                    
                    showSimpleAlert(title: "Invalid Configuration Name")
                    
                }
                
            }
          
        })
        
        config.placeholder = "Configuration Name"
        
        let alert = UIAlertController(alert: config)
        viewController.present(alert, animated: true, completion: nil)
        
        
    }
    
    func getNewGroupName() -> String {
        
        let names = store.namedGroups.compactMap({$0.name})
        var number = 0
        let pattern = "Configuration"
        var newName: String
        repeat {
            number += 1
            newName = "\(pattern) \(number)"
        } while names.contains(newName)
        return newName
        
    }
    
    func showSimpleAlert(title: String, message: String? = nil) {
        
        let config = AlertConfiguration(showTextField: false, title: title, message: message, cancel: nil)
        let alert = UIAlertController(alert: config)
        viewController.present(alert, animated: true, completion: nil)
        
        
    }
}

struct NotificationProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotificationProfileEditView(viewController: .constant(nil))
        }
    }
}

