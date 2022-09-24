//
//  TriggerEditorView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 14/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct TriggerEditorView: View {
    
    @State var text = ""
    
    var body: some View {
        
        Form {
            
            Section {
               EmptyView()
            }
            
            
            Section(content: {
                
                TextField("Text", text: $text)
                   
            }, footer: { Text("Sends a notification when an event has 10 seconds remaining.")
                    .padding(.top, 1)
            })
            
            
                
        }
        .navigationTitle("New Trigger")
        .safeAreaInset(edge: .bottom, content: {
            
            VStack {
                
                Button(action: {}, label: {
                    
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: 300)
                    
                })
                    .tint(.orange)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.horizontal, 20)
                    .frame(height: 52, alignment: .center)
                
                Button(action: {}, label: {
                    
                    Text("Delete")
                    
                        .font(.headline)
                        .frame(maxWidth: 300)
                    
                })
                    
                    .tint(.red)
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .padding(.horizontal, 20)
                    .frame(height: 52, alignment: .center)
                    
                
            }
            
  
        
    })
    }
    
}

struct TriggerEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TriggerEditorView()
        }
        
        
    }
}
