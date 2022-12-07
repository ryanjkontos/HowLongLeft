//
//  NotificationGroupEditorView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 14/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct NotificationGroupEditorView: View {
    
    @ObservedObject var groupStore: GroupEditorStore
    @Binding var showing: String?
    @Binding var createDefault: Bool
    
    @State var name: String = ""
    @State var showError = false
    @State var viewController: UINavigationController?
    @State var textFieldFR: Bool = false
    @State var currentError: EditTriggerError?
    
    init(group: NotificationGroup, store: NotificationGroupStore, showingBinding: Binding<String?>, createDefault: Binding<Bool>) {
        self.groupStore = GroupEditorStore(group, store)
        _createDefault = createDefault
        _showing = showingBinding
    }
    
    var body: some View {
        
        List {
            
            ForEach(NotificationTrigger.TriggerType.allCases, id: \.self) { type in
                
                Section(content: {
                    
                    ForEach(getTriggers(for: type), id: \.self, content: { trigger in
                        
                        Button(action: {  }, label: {
                            
                            Text("\(type.rawValue): \(trigger.value)")
                                .foregroundColor(.primary)
                            
                        })
                            .id(trigger.id)
                                .contextMenu(menuItems: {
                                    
                                    Button(role: .destructive, action: {
                                        
                                       deleteTrigger(trigger)
                                        
                                        
                                    }, label: {
                                        Image(systemName: "trash")
                                        Text("Delete")
                                    })
                                        .foregroundColor(.red)
                                        
                                        
                                    
                                })
                                .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                    
                                    Button(action: { deleteTrigger(trigger)
                                        
                                    }, label: { Text("Delete") })
                                        .tint(.red)
                                })
                                
                                
                        
                        
                    })
                        
                    
                    Button(action: {
                        
                        editNewTrigger(type: type)
                        
                    }, label: {
                        
                        Text("Add \(getTriggerName(type: type)) Trigger")
                            .foregroundColor(.orange)
                        
                    })
                        .id("Add\(type)")
                    
                }, header: {
                    
                    Text("\(getTriggerName(type: type)) Triggers")
                    
                })
                    .id(type)
                    
                
                
            }
            
            Section(content: {
                
                Toggle(isOn: $groupStore.group.endTrigger, label: {Text("Event Start")})
                Toggle(isOn: $groupStore.group.startTrigger, label: {Text("Event End")})
                
            }, header: {
                
                Text("Status Triggers")
                
            })
                .tint(nil)
            
            
            Section(content: {
                
                if groupStore.group.groupType == .customGroup {
                
                Button(action: {
                    
                    showEditConfigNamePrompt()
                    
                }, label: {
                    Text("Edit Configuration Name")
                        
                    
                })
                
                Button(action: {
                    
                    pop()
                    
                    DispatchQueue.main.async {
                        
                        withAnimation {
                            groupStore.store.deleteGroup(groupStore.group)
                        }
                        
                       
                    }
                    
                }, label: {
                    Text("Delete Configuration")
                        .foregroundColor(.red)
                    
                })
                    
                } else {
                    
                    
                    Button(action: {
                        
                        createDefault = true
                        pop()
                    }, label: {
                        Text("Save As Reusable Configuration")
                            
                        
                    })
                        
                    
                }
                
                Button(role: .destructive, action: {
                    
                    withAnimation {
                        
                        for trigger in groupStore.group.triggers {
                            try? groupStore.group.removeTrigger(trigger)
                        }
                        
                        groupStore.group.startTrigger = false
                        groupStore.group.endTrigger = false
                        
                        groupStore.store.saveGroup(groupStore.group)
                        
                    }
                    
                    
                    
                }, label: {
                    Text("Delete All Triggers")
                })
                
            }, header: { Text("Options") })
            
        }
 
            
            
        .introspectNavigationController(customize: { navigationController in
            self.viewController = navigationController
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
        })
        .navigationTitle(getGroupName())
        .navigationBarTitleDisplayMode(.inline)

        .onAppear(perform: {
            
            name = groupStore.group.name ?? ""
            
            if name.isEmpty {
                textFieldFR = true
            }
            
            
        })
            
        

        .alert(isPresented: $showError, error: currentError, actions: {
            
            Button(action: {
                
            }, label: {
                
                Text("Dismiss")
                
            })
            
        })
        
        .tint(.orange)
        
        
    }
    
    func pop() {
        
        showing = nil
        
        self.viewController?.popToRootViewController(animated: true)
        
        
    }
    
    func deleteTrigger(_ trigger: NotificationTrigger) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                
                try? withAnimation {
                    try groupStore.group.removeTrigger(trigger)
                }
                
            
        }
        
    }
    
    func getTriggers(for type: NotificationTrigger.TriggerType) -> [NotificationTrigger] {
        
        switch type {

        case .timeUntil:
            return groupStore.group.startsInTriggers
        case .timeRemaining:
            return groupStore.group.endsInTriggers
        case .percentage:
            return groupStore.group.percentageTriggers
            
        }
        
    }
    
    func getTriggerName(type: NotificationTrigger.TriggerType) -> String {
        
        switch type {
            case .timeUntil:
                return "Time Until"
            case .timeRemaining:
                return "Time Remaining"
            case .percentage:
                return "Percentage"
        }
        
    }
    
    func getGroupName() -> String {
        
        if groupStore.group.groupType == .defaultGroup {
            return "Default Configuration"
        }
        
        return groupStore.group.name ?? "New Configuration"
        
        
    }

    func editNewTrigger(type: NotificationTrigger.TriggerType) {
        
        var title: String
        
        switch type {
            
        case .timeUntil:
            title = "New Time Until Trigger"
        case .timeRemaining:
            title = "New Time Remaining Trigger"
        case .percentage:
            title = "New Percentage Trigger"
        }
        
        var alertConfig = AlertConfiguration(showTextField: true, title: title, message: "Enter a number of minutes", placeholder: "Minutes", accept: "Done", cancel: "Cancel", keyboardType: .numberPad, action: { value in
            
            do {
        
                try withAnimation {
                 
                    if let value = value {
                        try groupStore.group.newTrigger(type, value: Int(value)!)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                            
                                groupStore.store.saveGroup(groupStore.group)
                            
                        }
                        
                        
                        
                        
                    }
                    
                } 
                
               
                
                
            }  catch {
                
                
                let error = error as! EditTriggerError
                
                self.currentError = error
                self.showError = true
                
               
            }
            
            
            
            
        })
        
        alertConfig.secondaryActionStyle = .destructive
        
        let alert = UIAlertController(alert: alertConfig)
        
        DispatchQueue.main.async {
            self.viewController?.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    func showEditConfigNamePrompt() {
        
        var config = AlertConfiguration(showTextField: true, title: "Edit Configuration Name", message: "", prefill: groupStore.group.name, action: { value in
            
            if let value = value {
                
                if value.isEmpty == false {
                    
                    // print("Setting name to \(value)")
                    self.groupStore.group.name = value
                    groupStore.store.saveGroup(groupStore.group)
                    
                } else {
                    
                    showSimpleAlert(title: "Invalid Configuration Name")
                    
                }
                
            }
    
            })
          
        config.placeholder = "Configuration Name"
        
        let alert = UIAlertController(alert: config)
        
        DispatchQueue.main.async {
            self.viewController?.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func showSimpleAlert(title: String, message: String? = nil) {
        
        let config = AlertConfiguration(showTextField: false, title: title, message: message, cancel: nil)
        let alert = UIAlertController(alert: config)
        viewController?.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}

/*struct NotificationGroupEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationGroupEditorView(showEditor: .constant(true), group: .sampleGroup())
    }
} */

class GroupEditorStore: ObservableObject {
    
    init(_ group: NotificationGroup, _ store: NotificationGroupStore) {
        self.group = group
        self.store = store
    }
    
    @Published var store: NotificationGroupStore
    @Published var group: NotificationGroup {
        
        didSet {
            
            withAnimation {
                store.saveGroup(group)
            }
            

        }
        
    }
    
}
