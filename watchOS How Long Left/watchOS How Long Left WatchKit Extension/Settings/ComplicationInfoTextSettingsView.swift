//
//  ComplicationInfoTextSettingsView.swift
//  How Long Left
//
//  Created by Ryan Kontos on 2/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct ComplicationInfoTextSettingsView: View {
    
    @ObservedObject var model = Model()
    
    var body: some View {
        Form {
            
            Section(content: {
                Toggle("Show Progress Bar for In-Progress Events", isOn: $model.progressBars)
                
            })
            
               
          Section(content: {
              
              Picker("Info Text",selection: $model.thirdRowMode, content: {
                  Text(ThirdRowSettingsListItem.nextEvent.rawValue)
                      .tag(ThirdRowSettingsListItem.nextEvent)
                  Text(ThirdRowSettingsListItem.location.rawValue)
                      .tag(ThirdRowSettingsListItem.location)
                  Text(ThirdRowSettingsListItem.time.rawValue)
                      .tag(ThirdRowSettingsListItem.time)
              })
          }, footer: {
              
              Text("Choose which infomation is displayed in the 3rd row of the Countdown + Info complication.")
              
          })
            
            Section(content: {
                
            
                Picker("Show Alternate Info Text for First 5 minutes of an event",selection: $model.altThirdRowMode, content: {
                    Text(ThirdRowSettingsListItem.off.rawValue)
                        .tag(ThirdRowSettingsListItem.off)
                    Text(ThirdRowSettingsListItem.nextEvent.rawValue)
                        .tag(ThirdRowSettingsListItem.nextEvent)
                    Text(ThirdRowSettingsListItem.location.rawValue)
                        .tag(ThirdRowSettingsListItem.location)
                    Text(ThirdRowSettingsListItem.time.rawValue)
                        .tag(ThirdRowSettingsListItem.time)
                })
               
            }, footer: {
                Text("This option will also override the display of the progress bar during this period.")
            })
            
            
            
         
            
            
            
        }.navigationTitle("Large Rectangular Complication")
       
    }
    
    class Model: ObservableObject {
        
        @Published var progressBars = HLLDefaults.complication.progressBar {
            didSet {
                
                HLLDefaults.complication.progressBar = progressBars
                ComplicationController.updateComplications(forced: true)
                
            }
        }
        
        @Published var thirdRowMode = ThirdRowSettingsListItem.createFromThirdRowMode(HLLDefaults.complication.mainThirdRowMode) {
            didSet {
                
                HLLDefaults.complication.mainThirdRowMode = ThirdRowSettingsListItem.convertToThirdRowMode(thirdRowMode) ?? .nextEvent
                ComplicationController.updateComplications(forced: true)
                
            }
        }
        
        @Published var altThirdRowMode = ThirdRowSettingsListItem.createFromThirdRowMode(HLLDefaults.complication.alternateThirdRowMode) {
            didSet {
                
                HLLDefaults.complication.alternateThirdRowMode = ThirdRowSettingsListItem.convertToThirdRowMode(altThirdRowMode)
                ComplicationController.updateComplications(forced: true)
                
            }
        }
        
        
    }
    
    enum ThirdRowSettingsListItem: String {
        case nextEvent = "Next Event"
        case location = "Event Location"
        case time = "Countdown Time"
        case off = "Off"
        
        static func convertToThirdRowMode(_ item: ThirdRowSettingsListItem) -> ThirdRowMode? {
            
            switch item {
                
            case .nextEvent:
                return .nextEvent
            case .location:
                return .location
            case .time:
                return .time
            case .off:
                return nil
            }
            
        }
        
        static func createFromThirdRowMode(_ mode: ThirdRowMode?) -> ThirdRowSettingsListItem {
            
            guard let mode = mode else { return .off }
            switch mode {
                
            case .nextEvent:
                return .nextEvent
            case .location:
                return .location
            case .time:
                return .time
            }
            
        }
        
    }
}

struct ComplicationInfoTextSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ComplicationInfoTextSettingsView()
                
        }
    }
}
