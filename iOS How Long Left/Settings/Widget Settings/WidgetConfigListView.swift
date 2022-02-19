//
//  WidgetConfigListView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct WidgetConfigListView: View {
    
    @ObservedObject var store = WidgetConfigurationStore()
    
    @State var activeGroupID: String?
    
    @State var viewController: UIViewController!
    
    @State var navigationController: UINavigationController?
    
    @State var showDeleteButton = false
    
    @State var createDefault = false
    
    var body: some View {
            
            List {
                
                Section(content: { EmptyView() }, header: { EmptyView() }, footer: {
                    
                    Text("Create a widget configuration here, then apply it to a widget by long pressing it and selecting \"Edit Widget\".")
                    
                })
                
                Section(content: {
                    
                    NavigationLink(destination: {
                        
                        WidgetConfigurationEditor(configObject: store.defaultGroup, activeGroupID: $activeGroupID)
                            .environmentObject(store)
                        
                    }, label: {
                        
                        Text("Default Configuration")
                        .foregroundColor(Color.primary) })
                    
                    
                }, footer: { Text("This configuration will be applied to new widgets.") })
                
                Section(content: {
                    
                    ForEach(store.customGroups, content: { group in
                        
                        NavigationLink(tag: group.id , selection: $activeGroupID, destination: {
                            
                            WidgetConfigurationEditor(configObject: group, activeGroupID: $activeGroupID)
                                .environmentObject(store)
                            
                        }, label: {
                            
                                
                                
                            Text(group.name)
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
                        
                        Text("New Configuration")
                        
                            .contextMenu(menuItems: {
                                
                                if store.customGroups.isEmpty == false {
                                    
                                    Button(role: .destructive, action: {
                                       
                                        
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                
                                                withAnimation {
                                                    store.customGroups.forEach({ store.deleteGroup($0) })
                                                }
                                                
                                                
                                            }
                                            
                                        
                                        
                                       
                                       
                                   }, label: {
                                       Image(systemName: "trash")
                                       Text("Delete All Configurations") })
                                    
                                }
                                
                                
                            })
                          //  .id(UUID())
                        
                    })
                        
                    
                        
                        
                    
                    
                }, header: {
                    
                    Text("Custom Configurations")
                    
                }, footer: {
                
                    Text("Custom configurations can be created and applied to widgets.")
                    
                })
                    
                
                
            }
           
            .introspectViewController(customize: {
                
                self.viewController = $0
                
            })
        
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
            .navigationBarTitle("Manage Configurations")
            

            

    }
    
    @ViewBuilder
    func getGroupActions(for group: HLLTimelineConfiguration, showImages: Bool) -> some View {
        
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
        
        var config = AlertConfiguration(showTextField: true, title: "New Configuration", message: "", prefill: getNewGroupName() ,action: { value in
            
            if let value = value {
                
                if !value.isEmpty {
    
                    var new = HLLTimelineConfiguration.newCustomConfig()
                    new.name = value

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
        
        let names = store.customGroups.compactMap({$0.name})
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

struct WidgetConfigListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WidgetConfigListView()
        }
    }
}
