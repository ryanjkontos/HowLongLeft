//
//  EventView.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 19/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import EventKitUI


struct EventView: View {
   
    
    @State var showEditView = false
    
    @State var nicknaming: HLLEvent?
    
    @ObservedObject var data: EventOptionsViewObject
    
    static var eventViewTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(event: HLLEvent) {
      //  // print("Init event view for \(event.title)")
       
        self.event = event
        
        self.data = EventOptionsViewObject(event)
        
    }
    
    @State var items = [HLLEventInfoItem]()
    var event: HLLEvent
    
   
    var body: some View {
         
            List {
                
                VStack(alignment: .center) {
             
                    HStack {
                        Spacer()
                        
                        CountdownCardRepresentor(event: event, enableContextMenu: false, nicknaming: $nicknaming, eventSource: nil)
                            .frame(maxWidth: 550)
                            .frame(height: 123)
                            .id(event.infoIdentifier)
                            //.layoutPriority(1)
                        
                        Spacer()
                    }
                    
                 
                }
                
                
                .listRowBackground(Color.clear)
                
                Section(header: Text("Info")) {
                    
                    ForEach(items) { item in
                        
                        HStack {
                            
                            Text(item.title)
                            Spacer()
                            Text(item.info)
                                .foregroundColor(.secondary)
                            
                        }
                        .id(item.info)
                        
                    }
                    
                    
                }
                
                Section(content: {
                    
                    EventOptionsButtonsView(nicknaming: $nicknaming, presenting: .constant(false))
                        .environmentObject(data)
                    
                    
                }, header: {
                    Text("Options")
                })
                
        
            }
            .sheet(isPresented: $showEditView, onDismiss: {
                //selectionStateObject.update()
            }, content: {
                EventEditView(event: event, showSheet: $showEditView)
                    
            })
        
            .onReceive(EventView.eventViewTimer) { _ in
                
               update()
                
                
            }
                
            .onAppear() {
                update()
            }
        
            .sheet(item: $nicknaming, content: { event in
                
                NavigationView {
                    
                    NickNameEditorView(NicknameObject.getObject(for: event), store: NicknameManager.shared, presenting: Binding(get: { return nicknaming != nil }, set: { _ in nicknaming = nil }))
                        .tint(.orange)
                    
                }
                
            })
           /* .introspectNavigationController(customize: { navigationController in
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
            }) */
           //.navigationTitle("\(event.title)")
            .navigationBarTitleDisplayMode(.inline)
           /* .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { eventViewEvent = nil }) {
                        
                      Text("Done")
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        
                           
                    }
                }
            } */
                
            

    }
    
    func update() {
        
        let newItems = HLLEventInfoItemGenerator(event).getInfoItems(for: [.start, .end, .duration, .elapsed])
        if newItems != self.items {
            self.items = newItems
        }
        
    }
    
  
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(event: .previewEvent())
    }
}

class SelectionStateObject: ObservableObject, EventSourceUpdateObserver {
    func eventsUpdated() {
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    
     init(event: HLLEvent) {
        
        
        
        self.event = event
        self.isPinned = event.isPinned
        self.isSelected = event.isSelected
        
        HLLEventSource.shared.addeventsObserver(self)
       
    }
    
    @Published var event: HLLEvent
    
    var latestIDPinned = UUID()
    var latestIDSelected = UUID()
    
    func update() {
        
        if let updated = event.getUpdatedInstance() {
            event = updated
        }
        
        self.isPinned = event.isPinned
        self.isSelected = event.isSelected
        
    }
    
    
    @Published var isPinned: Bool {
        willSet {
            
            let id = UUID()
            latestIDPinned = id
     
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                
                
                EventPinningManager.shared.setPinned(newValue, for: self.event)
                
            }
            
        }
    }
    
   @Published var isSelected: Bool {
        willSet {
            
            let id = UUID()
            latestIDSelected = id
     
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                
            
                SelectedEventManager.shared.setSelection(newValue, for: self.event)
            }
            
        }
    }
 

    
}

struct EventEditView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = EKEventEditViewController
    
    var event: HLLEvent

    @Binding var showSheet: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<EventEditView>) -> EKEventEditViewController {
        let controller = EKEventEditViewController()
        controller.event = event.ekEvent
        controller.editViewDelegate = context.coordinator
        controller.navigationBar.tintColor = .systemOrange
        controller.view.tintColor = .systemOrange
        controller.eventStore = CalendarReader.shared.eventStore
        controller.view.backgroundColor = .systemGroupedBackground
        return controller
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: UIViewControllerRepresentableContext<EventEditView>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        
        init(_ parent: EventEditView) {
            self.parent = parent
        }
        
        var parent: EventEditView
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            self.parent.showSheet = false
        }
        
    }
    
    
}


