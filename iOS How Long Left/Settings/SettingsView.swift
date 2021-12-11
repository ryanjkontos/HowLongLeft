//
//  SettingsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct SettingsView: View {
    
    @ObservedObject var calendarsManager = EnabledCalendarsManager()
    
    @State var sheetRow: SettingsViewRow?

    @State var hasSetInitalSelection = false
    
    
    @State var tableView: UITableView?
    
    let sections: [SettingsViewSection] = [
        SettingsViewSection(rows: [.countdowns, .events, .calendars, .notifications, .appearance]),
        SettingsViewSection(header:"Extensions", rows: [.widget, .complication, .siri])
    ]
    
    @Environment(\.horizontalSizeClass) var horizontalSize
    
    @State var selection: String?
    @State var cells = [String:UITableViewCell]()
    
    @State var id = UUID()
    
    var body: some View {
        
        
        NavigationView {
        List {
            Section { EmptyView() }
            ForEach(sections, id: \.self) { section in
                Section(content: {
                    ForEach(section.rows, id: \.self) { row in
                        if let action = getRowAction(for: row) {
                            NavigationLink(isActive: Binding(get: { return false }, set: { _ in
                                action()
                            }), destination: {EmptyView()}, label: { getRowView(for: row) })
                               
                            
                        } else {
                            NavigationLink(tag: row.rawValue, selection: Binding(get: { return selection }, set: { value in
                                deselectRows()
                                selection = value
                            }), destination: { getRowDestination(for: row) }, label: { getRowView(for: row) })
                                
                        }
                    }
                }, header: {
                    if let title = section.header { Text(title) } else { EmptyView() }
                })
                    
            }
            
        }
            
            
        .navigationBarTitle("Settings")
        .introspectTableView(customize: {
            
            self.tableView = $0
            
        })
            
        }
 
        

        .onAppear() {
            
            if hasSetInitalSelection == false {
                hasSetInitalSelection = true
                
                if horizontalSize != .compact {
                    selection = SettingsViewRow.countdowns.rawValue
                } else {
                    selection = nil
                }
             
            }
            
            
            for cell in cells.values {
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.insetGrouped)
        .sheet(item: $sheetRow, onDismiss: { sheetRow = nil }, content: { rowType in
            Text(rowType.rawValue)
        })
            
            
        
    }
    
    func getRowAction(for type: SettingsViewRow) -> (() -> ())? {
        
        
        if [SettingsViewRow.complication, .siri, .widget].contains(type) {
            return { self.sheetRow = type }
        }
        
        return nil
        
    }
    
    
    @ViewBuilder func getRowDestination(for type: SettingsViewRow) -> some View {
        
        switch type {
        case .events:
            Text("Events")
        case .calendars:
            EnabledCalendarsView()
                .environmentObject(calendarsManager)
        case .countdowns:
            CountdownCardSettingsView()
        case .notifications:
            Text("Notifications")
        case .siri:
            Text("Siri")
        case .widget:
            Text("Widget")
        case .complication:
            Text("Complication")
        case .appearance:
            AppearanceSettings(appAppearance: .constant(.auto))
        }
        
    }
    
    @ViewBuilder
    func getRowView(for type: SettingsViewRow) -> some View {
        
        switch type {
        case .calendars:
            IconCell(label: "Calendars", iconImageName: "calendar", iconBackground: .orange, iconFill: .white)
        case .countdowns:
            IconCell(label: "Countdowns", iconImageName: "hourglass", iconBackground: .orange, iconFill: .white)
        case .notifications:
            IconCell(label: "Notifications", iconImageName: "bell.badge.fill", iconBackground: .orange, iconFill: .white)
        case .siri:
            IconCell(label: "Siri Shortcut", iconImageName: "mic.fill", iconBackground: .white, iconFill: .orange)
        case .widget:
            IconCell(label: "Widget", iconImageName: "apps.iphone", iconBackground: .white, iconFill: .orange)
        case .complication:
            IconCell(label: "Watch Complication", iconImageName: "applewatch.watchface", iconBackground: .white, iconFill: .orange)
        case .events:
            IconCell(label: "Events", iconImageName: "calendar.day.timeline.trailing", iconBackground: .orange, iconFill: .white)
        case .appearance:
            IconCell(label: "Appearance", iconImageName: "paintbrush.pointed.fill", iconBackground: .orange, iconFill: .white)
        }
        
    }
    
    private func deselectRows() {
        
        if horizontalSize == .regular {
            return
        }
        
        if let tableView = tableView, let selectedRow = tableView.indexPathForSelectedRow {
            
            UIView.animate(withDuration: 0.15, animations: {
                tableView.deselectRow(at: selectedRow, animated: true)
                
            })
            
            
        }
    }
    
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}

extension UIView {
    #if targetEnvironment(macCatalyst)
    @objc(_focusRingType)
    var focusRingType: UInt {
        return 1 //NSFocusRingTypeNone
    }
    #endif
}

struct SettingsViewSection: Hashable {
    
    var header: String?
    var rows: [SettingsViewRow]
    
}

enum SettingsViewRow: String, Identifiable {
    var id: SettingsViewRow { return self }
    
    
    case appearance = "Appearance"
    case events = "Events"
    case calendars = "Calendars"
    case countdowns = "Countdowns"
    case notifications = "Notifications"
    case siri = "Siri"
    case widget = "Widget"
    case complication = "Complication"
    
    
}

