//
//  MUWeekListInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 13/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import WatchKit
import Foundation



class MUWeekListInterfaceController: WKInterfaceController {

    var data = [DateOfEvents]()
    
    @IBOutlet weak var table: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setTitle("More Upcoming")
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        loadData()
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadData() {
        
        data = HLLEventSource.shared.getArraysOfUpcomingEventsForNextSevenDays(returnEmptyItems: true, allowToday: true)
        
        table.setNumberOfRows(data.count, withRowType: "DayRow")
        
        for (index, item) in data.enumerated() {
            
            let controller = table.rowController(at: index) as! DayRow
            controller.setup(item)
            
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        let selectedData = data[rowIndex]
        self.pushController(withName: "MUEventListView", context: selectedData)
        
    }

}


class DayRow: NSObject {
    
    @IBOutlet weak var mainLabel: WKInterfaceLabel!
    @IBOutlet weak var secondaryLabel: WKInterfaceLabel!
    
    func setup(_ item: DateOfEvents) {
        
        mainLabel.setText(item.date.getDayOfWeekName(returnTodayIfToday: true))
        secondaryLabel.setText("\(item.events.count) Upcoming")
        
    }
    
}
