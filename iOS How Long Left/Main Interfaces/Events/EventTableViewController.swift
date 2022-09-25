//
//  EventTableViewController.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 23/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    var card: CountdownCellView!
    
    var event: HLLEvent!
    
    var infoItems = [HLLEventInfoItem]()
    
    var menu: UIMenu!
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
        self.navigationItem.title = event.title
        self.navigationItem.largeTitleDisplayMode = .never
        
        let eventView = UIView()
        eventView.frame.size.height = 180
        //eventView.backgroundColor = .systemBlue
        
        card = CountdownCellView()
        card.configure()
        card.configureForEvent(event: event)
        menu = EventContextMenuGenerator.shared.getContextMenu(for: event, delegate: self)
        
        card.updateCountdownLabel()
        
        card.translatesAutoresizingMaskIntoConstraints = false
        
        eventView.addSubview(card)
        
        let trailing = card.trailingAnchor.constraint(lessThanOrEqualTo: eventView.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        let leading = card.leadingAnchor.constraint(greaterThanOrEqualTo: eventView.safeAreaLayoutGuide.leadingAnchor, constant: 30)
        let width = card.widthAnchor.constraint(greaterThanOrEqualToConstant: 500)
        
        trailing.priority = .required
        leading.priority = .required
        width.priority = .required
        
        NSLayoutConstraint.activate([
            
           
            trailing,
            leading,
            width,
            card.heightAnchor.constraint(equalToConstant: 125),
            card.centerYAnchor.constraint(equalTo: eventView.centerYAnchor),
            card.centerXAnchor.constraint(equalTo: eventView.centerXAnchor),
            
            
        ])
        
    
        
        self.tableView.tableHeaderView = eventView
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateInfoItems()
        self.card.updateCountdownLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            DispatchQueue.main.async {
                self.card.updateCountdownLabel()
                self.updateInfoItems()
            }
            
           
            
        }
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return infoItems.count
        } else {
            return menu.children.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Info"
        } else {
            return "Options"
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        if indexPath.section == 0 {
            
            let item = self.infoItems[indexPath.row]
            
            var config = UIListContentConfiguration.valueCell()
            config.text = item.title
            config.secondaryText = item.info
            
            cell.contentConfiguration = config
            cell.selectionStyle = .none
            
        } else {
           
            let item = menu.children[indexPath.row]
            
            var config = UIListContentConfiguration.cell()
            config.text = item.title
            config.textProperties.color = .systemOrange
            
            cell.contentConfiguration = config
            cell.selectionStyle = .default
            
        }
        

        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            
            let item = menu.children[indexPath.row] as! UIAction
            
            
            DispatchQueue.main.async {
                item.handler(item)
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.menu = EventContextMenuGenerator.shared.getContextMenu(for: self.event, delegate: self)
                    tableView.reloadData()
                    
                }
                    
                
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateInfoItems() {
        
        let newItems = HLLEventInfoItemGenerator(event).getInfoItems(for: [.location, .start, .end, .duration, .elapsed])
        
        if newItems != self.infoItems {
            
            self.infoItems = newItems
            
           
                self.tableView.reloadData()
            
            
        }
        
    }

}

extension EventTableViewController: EventContextMenuDelegate {
    func closeEventView(event: HLLEvent) {
        
        if self.event == event {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    
    func nicknameEvent(event: HLLEvent) {
        
        let object = NicknameObject.getObject(for: event)
        let vc = NicknameEditorTableViewController(style: .insetGrouped)
        vc.object = object
        self.present(HLLNavigationController(rootViewController: vc), animated: true)
        
    }
    
}

extension UIAction {
    var handler: UIActionHandler {
        get {
            typealias ActionHandlerBlock = @convention(block) (UIAction) -> Void
            let handler = value(forKey: "handler") as AnyObject
            return unsafeBitCast(handler, to: ActionHandlerBlock.self)
        }
    }
}
