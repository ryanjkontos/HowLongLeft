//
//  EventInfoView.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 2/10/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import SwiftUI

struct EventInfoView: View {
    
    let generator = HLLEventUniversalMenuItemGenerator()
    
    @State var event: HLLEvent
    
    var body: some View {

        GeometryReader { proxy in
        
        ScrollView {
            
            VStack(spacing: 1) {
                
                Text("Event ends in")
                    .font(Font.system(size: 30, weight: .medium, design: .default))
                
                Text("00:00")
                    .font(Font.system(size: 50, weight: .semibold, design: .default))
                    .foregroundColor(Color(event.uiColor))
                
            }
            .padding(.top, 40)
            .frame(width: proxy.size.width)
        
            
            List {
                
                
                
            }
            .listStyle(InsetGroupedListStyle())
            
        
        }
        
        
        }
        .navigationBarItems(trailing: Menu(content: {
            
            ForEach(generator.generateUniversalMenuItems(for: event), content: { item in
                
                Menu("Menu", content: {
                    
                    ForEach(item.items, content: { subItem in
                        
                        Button(action: subItem.action ?? {}, label: {
                            Image(uiImage: subItem.image!)
                            Text(subItem.title)
                        })
                        
                    })
                    
                })
                
                
            })
            
            
        }, label: { Image(systemName: "ellipsis")}))
        
            
    }
    
}

struct EventInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EventInfoView(event: .previewEvent())
        
    }
        
}
