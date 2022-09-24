//
//  InProgressParentView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import Introspect

struct CountdownsParentView: View {
    
    @ObservedObject var eventSource = EventSource()
    @Binding var eventViewEvent: HLLEvent?
    
    @State var showSettings = false
    
    @Binding var launchEvent: HLLEvent?
    
    @State var navigationController: UINavigationController?
    
    var body: some View {
        
        CountdownsViewRepesentor()
            
    }
}

struct InProgressParentView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownsParentView(eventViewEvent: .constant(nil), launchEvent: .constant(nil))
    }
}
