//
//  UpcomingEventsTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 31/3/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit
    
class UpcomingEventsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ScrollUpDelegate, EventSourceUpdateObserver {
    
        var events = [HLLEvent]()
        var eventDates = [DateOfEvents]()
        var lastReadReturnedNoCalendarAccess = false
        var endCheckTimer: Timer!
        var previewingEvent: HLLEvent?
        
        @IBOutlet weak var tableView: UITableView!
    
        override func viewDidLoad() {
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            HLLEventSource.shared.addeventsObserver(self)
            
            self.navigationItem.title = "Upcoming"
            
            
            self.endCheckTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.checkForEnd), userInfo: nil, repeats: true)
            
            
        }
    
    

        @objc func calendarDidChange() {
            
            updateCountdownData()
            
            
        }
        
    @objc func checkForEnd() {
        
        
        for event in self.events {
            
            if event.endDate.timeIntervalSince(CurrentDateFetcher.currentDate) > 0 {
                
                
                self.updateCountdownData()
                
            }
            
        }
        
        
    }

    var gotAccess = false
    
    @objc func gotCalAccess() {
    
        if gotAccess == false {
            
            gotAccess = true
            updateCountdownData()
            
        }
    
    }
    
       @objc func updateCountdownData() {
        
        let prev = self.eventDates
        
        self.eventDates = HLLEventSource.shared.getArraysOfUpcomingEventsForNextSevenDays(returnEmptyItems: false, allowToday: true)
        
        
        if prev != self.eventDates || prev.isEmpty {
            self.tableView.reloadData()
        }

   
    }
        
    override func viewWillAppear(_ animated: Bool) {
            
        self.updateCountdownData()
            
        DispatchQueue.main.async {
            
        RootViewController.selectedController = self
            
        }
            
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        return eventDates[section].events.count
            
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let event = eventDates[indexPath.section].events[indexPath.row]
            
            let iden = "UpcomingEventCellLocation"
            
            if event.location != nil {
                
               // iden = "UpcomingEventCellLocation"
                
            }
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: iden, for: indexPath) as! UpcomingEventsTableRow            
            cell.generate(from: event)
            
            if RootViewController.hasFadedIn == false {
                cell.alpha = 0
                
                UIView.animate(withDuration: 0.30, animations: {
                    cell.alpha = 1
                })
            }

            
            return cell
            
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Upcoming \(eventDates[section].headerString!)"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if RootViewController.hasFadedIn == false {
        
        view.alpha = 0
        
        UIView.animate(withDuration: 0.30, animations: {
            
            view.alpha = 1
            
        })
            
        }
        
    }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            
            var areEvents = false
            
            if let day = eventDates.first {
                
                if day.events.isEmpty == false {
                    
                    areEvents = true
                    
                }
                
            }
        
            
            if areEvents == true || HLLEventSource.shared.neverUpdatedevents {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView = nil
                
                
            } else {
                
                RootViewController.hasFadedIn = true
                
                var text = "No Upcoming Events"
                
                
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
            
            return eventDates.count
        }
        
         func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
            let event = eventDates[indexPath.section].events[indexPath.row]
               
               let viewController = EventInfoViewGenerator.shared.generateEventInfoView(for: event)
               
            
              if let split = self.splitViewController {
                   
                var push = false
                
                if split.viewControllers.indices.contains(1) {
                    
                    if let detailView = split.viewControllers[1] as? UINavigationController {
                        
                        if detailView.viewControllers.count > 1 {
                            
                            detailView.pushViewController(viewController, animated: true)
                            push = true
                            
                        }
                        
                    }
                    
                    
                }
                
                if push == false {
                    
                    let nav = HLLNavigationController(rootViewController: viewController)
                    nav.navigationBar.isHidden = true
                    split.viewControllers = [self, nav]
                    
                }
                
                
                   
                   
               } else {
                   self.navigationController?.pushViewController(viewController, animated: true)
                   tableView.deselectRow(at: indexPath, animated: true)
               }
           }
           
    func scrollUp() {
        
        if self.tableView.numberOfSections > 0, self.tableView.numberOfRows(inSection: 0) > 0 {
            
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    
                    RootViewController.hasFadedIn = true
                })
                
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            let event = eventDates[indexPath.section].events[indexPath.row]
            let destination = (segue.destination as! EventInfoViewController)
            destination.event = event
            
        }
        
    }
    
    func eventsUpdated() {
        DispatchQueue.main.async {
            
            self.updateCountdownData()
            

        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
}

@available(iOS 11.0, *)
extension UpcomingEventsTableViewController {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var actions = [UIContextualAction]()
        
        let event = eventDates[indexPath.section].events[indexPath.row]
        
     
        let action = UIContextualAction(style: .normal, title: "Options",
          handler: { (action, view, completionHandler) in
            
            let alertController = HLLEventActionSheetGenerator.shared.generateActionSheet(for: event, isFollowingOccurence: event.followingOccurence != nil)
            self.present(alertController, animated: true, completion: nil)
            
          
          completionHandler(true)
            
        })
        
        action.image = UIImage(named: "ellipsis.circle.fill")
        action.backgroundColor = .systemGray
        
        actions.append(action)
        
       
        
        let configuration = UISwipeActionsConfiguration(actions: actions)
        return configuration
        
    }
    
}

@available(iOS 13.0, *)
extension UpcomingEventsTableViewController {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let event = eventDates[indexPath.section].events[indexPath.row]
        
        previewingEvent = event
        
        
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: {
                                            
                                            
                                              return EventInfoViewGenerator.shared.generateEventInfoView(for: event)
                                            
        },
                                            actionProvider: { _ in
                                            return HLLEventContextMenuGenerator.shared.generateContextMenuForEvent(event)  })
        
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        animator.addCompletion {
            
            if let event = self.previewingEvent {
            
            
            let viewController = EventInfoViewGenerator.shared.generateEventInfoView(for: event)
            self.show(viewController, sender: self)

                
            }
            
            
        }
        
    }
    
    
    
}

extension UpcomingEventsTableViewController: EventInfoViewPresenter {
    
    func presentEventInfoView(for event: HLLEvent) {
        
        self.navigationController?.popViewController(animated: true)
        let viewController = EventInfoViewGenerator.shared.generateEventInfoView(for: event)
        self.navigationController?.pushViewController(viewController, animated: true)
    
    }
    
}
