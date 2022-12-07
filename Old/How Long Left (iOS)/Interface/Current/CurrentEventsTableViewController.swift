//
//  CurrentEventsTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 31/3/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit
#if canImport(Intents)
import Intents
import IntentsUI
#endif

class CurrentEventsTableViewController: UITableViewController {
    
    var timer: Timer!
    var events = [HLLEvent]()
    var previewingEvent: HLLEvent?
    
    override func viewDidLoad() {
        
        
        HLLEventSource.shared.addeventsObserver(self)
        
        updateCells()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(self.updateCells), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
        updateEvents()
        RootViewController.selectedController = self
        
       DispatchQueue.main.async {
        

            BackgroundFunctions.shared.run()
        }
        
        
        
        
    }
    
    func updateEvents() {
        
        let oldEvents = self.events
        self.events = HLLEventSource.shared.getCurrentEvents(includeHidden: true)
      
        
        if self.events != oldEvents || oldEvents.isEmpty {

            self.tableView.reloadData()
            
        
        }
        
    }
    
    @objc func updateCells() {
        
        for cell in tableView.visibleCells {
            
            if let currentCell = cell as? CurrentEventCell {
                
                if currentCell.event.completionStatus == .current {
                    
                    DispatchQueue.main.async {
                    currentCell.updateCell()
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        self.updateEvents()
                    }
                    
                }
                
            }
            
            

            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if HLLDefaults.currentEventView.showPercentageLabels {
            return 125
        } else {
            return 105
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellID = "DefaultCurrentEventCell"
        if HLLDefaults.currentEventView.showPercentageLabels {
            cellID = "DetailCurrentEventCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        (cell as! CurrentEventCell).setup(with: events[indexPath.section])
        
        #if targetEnvironment(macCatalyst)
        cell.selectionStyle = .blue
        #endif
        
        if RootViewController.hasFadedIn == false {
        
        cell.alpha = 0
            
        UIView.animate(withDuration: 0.30, animations: {
            cell.alpha = 1
        })
            
        }
        
        return cell
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
       setupBackground()
        
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
        
            
            let event = self.events[indexPath.section]
            let viewController = EventInfoViewGenerator.shared.generateEventInfoView(for: event)
            
            if let split = self.splitViewController {
                
                split.viewControllers = [self, viewController]
                
            } else {
                self.navigationController?.pushViewController(viewController, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
    
        }
    }
    
    func setupBackground() {
        
        if events.isEmpty == false || HLLEventSource.shared.neverUpdatedevents {
                   
                   tableView.backgroundView = nil
                   
               } else {
                   
                RootViewController.hasFadedIn = true
                var text = "No Current Events"
                
                if HLLDefaults.calendar.enabledCalendars.count == 0 {
                    text = "No Enabled Calendars"
                }
            
                if HLLEventSource.shared.access != .Granted {
                    text = "No Calendar Access"
                }
                    
                   
                   let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                   noDataLabel.text          = text
                   noDataLabel.textColor     = UIColor.lightGray
                   noDataLabel.font = UIFont.systemFont(ofSize: 18)
                   noDataLabel.textAlignment = .center
                   
                   tableView.backgroundView  = noDataLabel
                   tableView.separatorStyle  = .none
                    
               }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                RootViewController.hasFadedIn = true
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
}

@available(iOS 11.0, *)
extension CurrentEventsTableViewController {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var actions = [UIContextualAction]()
        
        let event = self.events[indexPath.section]
        
         
         let action = UIContextualAction(style: .normal, title: "Options",
           handler: { (action, view, completionHandler) in
             
             let alertController = HLLEventActionSheetGenerator.shared.generateActionSheet(for: event, isFollowingOccurence: event.followingOccurence != nil)
             self.present(alertController, animated: true, completion: nil)
             
           
           completionHandler(true)
             
         })
         
         action.image = UIImage(named: "ellipsis.circle.fill")
            action.backgroundColor = .systemGray
         
         actions.append(action)
        
        var title = "Show Percent"
        if HLLDefaults.currentEventView.showPercentageLabels {
          title = "Hide Percent"
        }
        
        let percentagesAction = UIContextualAction(style: .normal, title: title,
                  handler: { (action, view, completionHandler) in
                    
                    HLLDefaults.currentEventView.showPercentageLabels = !HLLDefaults.currentEventView.showPercentageLabels
                    HLLDefaultsTransfer.shared.userModifiedPrferences()
                    completionHandler(true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        tableView.reloadData()
                    }
                    
                })
                
                percentagesAction.image = UIImage(named: "percent")
            percentagesAction.backgroundColor = .systemBlue
                
                actions.append(percentagesAction)
         
        
         
         let configuration = UISwipeActionsConfiguration(actions: actions)

         return configuration
        
    }
    
}

extension CurrentEventsTableViewController: EventSourceUpdateObserver {
    
    func eventsUpdated() {
        // print("CEU")
        
        DispatchQueue.main.async {
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.updateEvents()
            
            
        }
    }
    
}

extension CurrentEventsTableViewController: EventInfoViewPresenter {
    
    func presentEventInfoView(for event: HLLEvent) {
        
        self.navigationController?.popViewController(animated: true)
        let viewController = EventInfoViewGenerator.shared.generateEventInfoView(for: event)
        self.navigationController?.pushViewController(viewController, animated: true)
    
    }
    
}

extension CurrentEventsTableViewController: ScrollUpDelegate {
    
    func scrollUp() {
        
        if self.tableView.numberOfSections > 0, self.tableView.numberOfRows(inSection: 0) > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
    }
    
}

@available(iOS 13.0, *)
extension CurrentEventsTableViewController {
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let event = events[indexPath.section]
        previewingEvent = event
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: {
                                            
                                            
                                              return EventInfoViewGenerator.shared.generateEventInfoView(for: event)
                                            
        },
                                        actionProvider: { _ in
                                            return HLLEventContextMenuGenerator.shared.generateContextMenuForEvent(event)  })
        
    }
    
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        animator.addCompletion {
            
            if let event = self.previewingEvent {
            
            
            let viewController = EventInfoViewGenerator.shared.generateEventInfoView(for: event)
            self.show(viewController, sender: self)

                
            }
            
        }
        
    }
    
}
