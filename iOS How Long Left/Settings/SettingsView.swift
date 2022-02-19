//
//  SettingsView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect
import WatchConnectivity

struct SettingsView: View {
    
    @State var sheetRow: SettingsViewRow?
    
    @State var hasSetInitalSelection = false
    
    @State var nVc: UIViewController?
    
    @State var tableView: UITableView?
    
    @State var complicationPurchased = false
    
    @State var widgetPurchased = false
    
    var store = Store.shared
    
    var sections: [SettingsViewSection]
    
    var sheetRowBinding: Binding<Bool> {
        Binding(get: { return sheetRow != nil }, set: { _ in sheetRow = nil })
    }
    
    init() {
        
        sections = [SettingsViewSection(rows: [.countdowns, .events, .calendars])]
        var extensionSection: [SettingsViewRow] = [.widget]
        if WCSession.isSupported() { extensionSection.append(.complication) }
        extensionSection.append(.siri)
        sections.append(SettingsViewSection(header: "Extensions", rows: extensionSection))
        sections.append(SettingsViewSection(rows: [.debug]))
        
        updatePurchases()
        
    }
        
    func updatePurchases() {
    
        Task {
            
            await Store.shared.refreshPurchasedProducts()
            
            complicationPurchased = Store.shared.complicationPurchased
            widgetPurchased = Store.shared.widgetPurchased
            
        }
        
      
        
    }

    @Environment(\.horizontalSizeClass) var horizontalSize
    
    @State var selection: String?
    @State var cells = [String:UITableViewCell]()
    
    @State var id = UUID()
    
    var body: some View {
        
        List {
          //  Section { EmptyView() }
            ForEach(sections, id: \.self) { section in
                Section(content: {
                    ForEach(section.rows, id: \.self) { row in
                        if let action = getRowAction(for: row) {
                           /* NavigationLink(isActive: Binding(get: { return false }, set: { _ in
                                action()
                            }), destination: {EmptyView()}, label: { getRowView(for: row) }) */
                            
                            Button(action: action, label: { getRowView(for: row)})
                                .id(row)
                               
                            
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
        
        .sheet(isPresented: sheetRowBinding, onDismiss: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                
                updatePurchases()
            }
            
        }, content: {
            
            getRowDestination(for: sheetRow!)
            
        })
        
      
     /*   .introspectNavigationController(customize: { vc in
            
            self.nVc = vc
            
        })
            
        //.navigationBarTitle("Settings")
        .introspectTableView(customize: {
            
            self.tableView = $0
            
        }) */


        .onAppear() {
            
            print("On appear")
            
            complicationPurchased = Store.shared.complicationPurchased
            widgetPurchased = Store.shared.widgetPurchased
            
            updatePurchases()
            
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

        
    }
    
    func getRowAction(for type: SettingsViewRow) -> (() -> ())? {
        
        if [SettingsViewRow.complication, .siri, .widget].contains(type) {
            
            switch type {
            case .widget:
                if widgetPurchased { return nil }
            case .complication:
                if complicationPurchased { return nil }
            default:
                break
            }
            
            return {
                
                self.sheetRow = type
            
            }
        }
        
        return nil
        
    }
    
    
    @ViewBuilder func getRowDestination(for type: SettingsViewRow) -> some View {
        
        switch type {
        case .events:
            Text("Events")
        case .calendars:
            EnabledCalendarsView()
               
        case .countdowns:
            CountdownViewSettings()
        case .notifications:
            NotificationProfileEditView(viewController: $nVc)
        case .siri:
            Text("Siri")
        case .widget:
            
            if widgetPurchased {
               WidgetSettingsView()
            } else {
                ExtensionPurchaseView(type: .widget, presentSheet: sheetRowBinding)
            }
            
            
        case .complication:
            
            if complicationPurchased {
                Text("Complication Settings")
            } else {
                ExtensionPurchaseView(type: .complication, presentSheet: sheetRowBinding)
            }
            
        case .appearance:
            AppearanceSettings(appAppearance: .constant(.auto))
        case .debug:
            DebugView()
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
        case .debug:
            IconCell(label: "Debug", iconImageName: "hammer.fill", iconBackground: .blue, iconFill: .white)
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
    case debug = "debug"
    
    
}

