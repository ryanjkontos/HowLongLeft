//
//  MUEventListInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 13/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import WatchKit
import Foundation



class MUEventListInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    var data: DateOfEvents!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        data = (context as! DateOfEvents)
        self.setTitle(data.date.getDayOfWeekName(returnTodayIfToday: true))
        loadTable()
       
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadTable() {
        
        let tableData = data!
        
        table.setNumberOfRows(tableData.events.count, withRowType: "MUEventRow")
        
        for (index, event) in tableData.events.enumerated() {
            
            let controller = table.rowController(at: index) as! MUEventRow
            controller.setup(event: event)
            
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        if let row = table.rowController(at: rowIndex) as? MUEventRow {
            
            let event = row.event
            self.pushController(withName: "EventInfoView", context: event)
        }
        
    }

}

class MUEventRow: NSObject {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var infoLabel: WKInterfaceLabel!
    var event: HLLEvent!
    
    func setup(event: HLLEvent) {
        
        self.event = event
        titleLabel.setText(event.title)
        infoLabel.setText(event.compactInfoText)
        titleLabel.setTextColor(event.uiColor)
        
    }
    
}
