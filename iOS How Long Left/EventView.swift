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
    
    @Binding var eventViewEvent: HLLEvent?
    
    @State var selectionStateObject: SelectionStateObject
    
    
    
    
    
    var body: some View {
        
        NavigationView {
            GeometryReader { proxy in
            List {
                
                HStack(alignment: .center) {
                
                    Spacer()
                    
                    CountdownCard(event: selectionStateObject.event)
                        .frame(maxWidth: 425)
                        .id(selectionStateObject.event.infoIdentifier)
                    
                    Spacer()
                }
                
                
                
                
                .listRowBackground(Color.clear)
                
                Section(header: Text("Info")) {
                    
                    ForEach(HLLEventInfoItemGenerator(selectionStateObject.event).getInfoItems(for: [.start, .end, .duration, .elapsed])) { item in
                        
                        HStack {
                            
                            Text(item.title)
                            Spacer()
                            Text(item.info)
                                .foregroundColor(.secondary)
                            
                        }
                        
                    }
                    
                }
                
                Section(content: {
                    
                    Toggle(isOn: $selectionStateObject.isPinned, label: {
                        
                        Image(systemName: "pin.fill")
                            .frame(width: 20)
                            .foregroundColor(.orange)
                        Text("Show in Pinned") })
                        
                    
                    Toggle(isOn: $selectionStateObject.isSelected, label: {
                        
                        Image(systemName: "square.fill")
                            .foregroundColor(.orange)
                        Text("Show in Widget") })
                    
                }, header: {
                    Text("Options")
                })
                
                if selectionStateObject.event.EKEvent?.calendar.isImmutable == false {
                
                Section {
                    Button(action: {showEditView.toggle()}, label: { Text("Edit") })
                }
                .tint(.orange)
                    
                }
            }
            .sheet(isPresented: $showEditView, onDismiss: {
                selectionStateObject.update()
            }, content: {
                EventEditView(event: selectionStateObject.event, showSheet: $showEditView)
                    .edgesIgnoringSafeArea(.all)
            })
         /*   .introspectNavigationController(customize: { navigationController in
                let appearance = UINavigationBarAppearance()
                appearance.configureWithDefaultBackground()
                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
            })*/
           // .navigationTitle("\(selectionStateObject.event.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { eventViewEvent = nil }) {
                        
                        
                        ZStack {
                            
                            Circle()
                                .foregroundColor(.secondary.opacity(0.4))
                                .frame(width: 32, height: 32)
                                
                                .opacity(0.5)
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                                .font(.system(size: 13.5, weight: .heavy, design: .rounded))
                            
                        }
                        .padding(.top, 7)
                        
                           
                    }
                }
            }
                
            }

        }
    }
    
  
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView(eventViewEvent: .constant(.previewEvent()), selectionStateObject: .init(event: .previewEvent()))
    }
}

class SelectionStateObject: ObservableObject, EventPoolUpdateObserver {
    func eventPoolUpdated() {
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    
    internal init(event: HLLEvent) {
        
        
        
        self.event = event
        self.isPinned = event.isPinned
        self.isSelected = event.isSelected
        
        HLLEventSource.shared.addEventPoolObserver(self)
       
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
        controller.event = event.EKEvent
        controller.editViewDelegate = context.coordinator
        controller.navigationBar.tintColor = .orange
        controller.view.tintColor = .orange
        controller.eventStore = HLLEventSource.shared.eventStore
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


