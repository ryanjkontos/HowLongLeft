//
//  WidgetConfigurationEditor.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI
import EventKit
import Introspect


struct WidgetConfigurationEditor: View {
    
    internal init(configObject: HLLTimelineConfiguration, activeGroupID: Binding<String?>) {
        self.configObject = configObject
        self.model = Model(configObject)
        _activeGroupID = activeGroupID
    }
    
    var configObject: HLLTimelineConfiguration
    
    @ObservedObject var model: Model
    
    var store = WidgetConfigurationStore()
    
    @State var viewController: UINavigationController?
    
    @Binding var activeGroupID: String?
    
    @State var textFieldText = ""
    
    var body: some View {
        
        List {
            
            if model.config.groupType == .customGroup {
               
                Section("Configuration Name") {
                    TextField("Name", text: $textFieldText, onCommit: {
                        
                        if textFieldText.isEmpty == false {
                            model.config.name = textFieldText
                        } else {
                            textFieldText = model.config.name
                        }
                        
                    })
                        .onAppear { textFieldText = model.config.name }
                }
                
                
            } else {
                
                Section(content: { EmptyView() }, header: { EmptyView() }, footer: {
                    
                    Text("This configuration will be applied to new widgets.")
                    
                })
                
                
            }
            
            Section(content: {
                Toggle("Show In Progress Events", isOn: $model.config.showCurrent.animation())
                Toggle("Show Upcoming Events", isOn: $model.config.showUpcoming.animation())
                
                if model.config.showCurrent, model.config.showUpcoming {
                

                    Picker(selection: Binding(get: { model.config.sortMode }, set: { model.config.sortMode = $0 }), content: {
                            
                            ForEach(TimelineSortMode.allCases) { option in
                                
                                
                                    Text("\(option.name)")
                       
                                
                                
                            }
                            
                        }, label: { Text("Prefer Showing") })
            
                }
                
            }, header: { Text("Event Status") })
            
        
            
            Section("Calendars") {
                Toggle("Use All Calendars", isOn: $model.config.useAllCalendars.animation())
                
            }
            
            if !model.config.useAllCalendars {
            
            Section("Enabled Calendars") {
                
             
                
                ForEach(CalendarReader.shared.getCalendars()) { calendar in
                    
                    Toggle(isOn: calendarBinding(calendar), label: {
                        HStack {
                            Circle()
                                    .frame(width: 11, height: 11, alignment: .center)
                                    .foregroundColor(Color(cgColor: calendar.cgColor))
                            Text(calendar.title)
                                    .padding(.leading, 5)
                            Spacer()
                        }
                    })
                        
                    
                }
                    
                }
                
            }
            
            if model.config.groupType == .customGroup {
            
                Section(content: {
                    
                    Button(action: {
                        
                        store.deleteGroup(model.config)
                        activeGroupID = nil
                        self.viewController?.popViewController(animated: true)
                    
                    }, label: {
                        
                        Text("Delete Configuration")
                            .foregroundColor(.red)
                        
                    })
                    
                }, footer: {
                    
                    Text(getConfigText())
                    
                })
                
          
                
            }
            
         
            
        }
        .navigationTitle(model.config.name)
        .navigationBarTitleDisplayMode(.inline)
        
        .onReceive(model.objectWillChange, perform: {
            
            DispatchQueue.main.async {
            
                // print("\(model.config.sortMode)")
                
                store.saveGroup(model.config)
                
            }
            
            
        })
        
        .introspectNavigationController(customize: { viewController = $0 })
        
    }

    func getConfigText() -> String {
        
        if let count = WidgetUpdateHandler.shared.configDict[self.model.config.id] {
            return "This configuration is currently in use by \(count) widget\(count != 1 ? "s" : ""). If you delete it, they will use the default configuration."
        }
        
        return "No widgets are currently using this configuration."
        
    }
    
    func calendarBinding(_ calendar: EKCalendar) -> Binding<Bool> {
        
        Binding(get: { model.config.enabledCalendarIDs.contains(where: { $0 == calendar.id }) }, set: { value in
            
            if value {
                model.config.enabledCalendarIDs.insert(calendar.calendarIdentifier)
            } else {
                model.config.enabledCalendarIDs.remove(calendar.calendarIdentifier)
            }
            
        })
        
    }
    

    class Model: ObservableObject {
        
        init(_ config: HLLTimelineConfiguration) {
            
            self.config = config
            
        }
        
        @Published var config: HLLTimelineConfiguration
        
       
        
    }
    
}



struct WidgetConfigurationEditor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WidgetConfigurationEditor(configObject: .newCustomConfig(), activeGroupID: .constant(nil))
        }
    }
}

extension EKCalendar: Identifiable {
    
    public var id: String { return self.calendarIdentifier }
    
}


