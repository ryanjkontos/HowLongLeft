//
//  EventInfoViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 10/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class EventInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sections = [[HLLEventInfoItem]]()
    var event: HLLEvent!
    let formatter = DateComponentsFormatter()
    var distanceFromRootOccurence = 0
    var cellUpdateTimer: Timer!
    var infoItemGenerator: HLLEventInfoItemGenerator!
    var willClose = false
    var isFollowingOccurence = false
    var activity: NSUserActivity?
    
    override func viewDidLoad() {

        
        var title = "\(self.event.title) Info"
        
        if let count = self.navigationController?.viewControllers.count {
            if count > 2 {
                title = "\(title) (\(count-1))"
            }
        }
        
        self.navigationItem.title = title
        self.getSections()
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ellipsis"), style: .plain, target: self, action: #selector(presentEventMenu))
        
        if let navigationController = self.navigationController, self.splitViewController != nil {
            
            if navigationController.viewControllers.count > 1 {
                navigationController.navigationBar.isHidden = false
            } else {
                navigationController.navigationBar.isHidden = true
            }
            
            
        } else {
            self.navigationController?.navigationBar.isHidden = false
        }
        
        //self.navigationController?.navigationBar.tintColor = self.event.uiColor
        super.viewWillAppear(animated)
        self.getSections()
        updateInfoRows()
        cellUpdateTimer = Timer(timeInterval: 0.25, target: self, selector: #selector(updateInfoRows), userInfo: nil, repeats: true)
        RunLoop.main.add(cellUpdateTimer, forMode: .common)
        
       /* if let newEvent = self.event?.getUpdatedInstance() {
            
            
            
            self.event = newEvent
            
            print("Pop1")
            self.navigationController?.popToRootViewController(animated: true)
            
        }*/
        
        let activityObject = NSUserActivity(activityType: "com.ryankontos.how-long-left.viewEventActivity")
             activityObject.title = event.title
             
            let id = event.persistentIdentifier
        
                print("Activity id = \(id)")
        
             activityObject.addUserInfoEntries(from: ["EventID":id])
             activityObject.isEligibleForHandoff = true
             activityObject.becomeCurrent()
             self.activity = activityObject
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.activity?.invalidate()
    }
    
    func getSections() {
        
        infoItemGenerator = HLLEventInfoItemGenerator(self.event)
        
        
        
        /*sections.append(infoItemGenerator.getInfoItems(for: [.completion]))
        sections.append(infoItemGenerator.getInfoItems(for: [.location]))
        sections.append(infoItemGenerator.getInfoItems(for: [.period]))
        sections.append(infoItemGenerator.getInfoItems(for: [.start]))
        sections.append(infoItemGenerator.getInfoItems(for: [.end]))
        sections.append(infoItemGenerator.getInfoItems(for: [.elapsed]))
        sections.append(infoItemGenerator.getInfoItems(for: [.duration]))
        //sections.append(infoItemGenerator.getInfoItems(for: [.calendar, .teacher]))
        sections.append(infoItemGenerator.getInfoItems(for: [.nextOccurence]))*/
        
        var newSections = [[HLLEventInfoItem]]()
        
        newSections.append(infoItemGenerator.getInfoItems(for: [.completion]))
        newSections.append(infoItemGenerator.getInfoItems(for: [.location, .oldLocationName, .originalLocation]))
        newSections.append(infoItemGenerator.getInfoItems(for: [.start, .end, .period]))
        newSections.append(infoItemGenerator.getInfoItems(for: [.elapsed, .duration]))
        newSections.append(infoItemGenerator.getInfoItems(for: [.teacher]))
        if HLLDefaults.general.showNextOccurItems {
        newSections.append(infoItemGenerator.getInfoItems(for: [.nextOccurence]))
        }
        
        
        
        self.sections = newSections.filter({ !$0.isEmpty })
        
    }
    
    func setup() {
        
        DispatchQueue.main.async {
            self.navigationItem.title = "\(self.event.title) Info"
            self.getSections()
            self.tableView.reloadData()
        }
        
    }
    
    @objc func updateInfoRows() {
        

        DispatchQueue.global(qos: .default).async {
        
        let previousSections = self.sections
        self.getSections()
               
        if self.sections != previousSections || self.sections.count != previousSections.count {
            self.setup()
        }
            
        let previousEvent = self.event
            
            if let event = self.event.getUpdatedInstance() {
                self.event = event
            // Matching event still exists
            
            if event != previousEvent {
                
                // ...But has been modified
                
                self.setup()
            }
                
        } else {
            
            // Matching event no longer exists
            
            DispatchQueue.main.async {
                print("Pop2")
                self.navigationController?.popViewController(animated: true)
            }
            
        }
  
        
        
            if self.event.completionStatus == .Done {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    
                    if let split = self.splitViewController {
                        
                        split.viewControllers.removeAll(where: {$0 == self})
                        
                    }
                    
                    print("Pop3")
                    self.navigationController?.popViewController(animated: true)
                    
                })
                
            }
            
        }
        
    
        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            let height = view.bounds.height*0.18
            
            if height < 100 {
                
                return 100
                
            } else {
                
                return height
                
            }
            
        } else {
            
            let realSection = indexPath.section-1
            let pair = sections[realSection][indexPath.row]
            
            if pair.type == .nextOccurence {
                return 64
            } else {
                return 43
            }
            
        }
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if section == 0 {
            return 1
        }
    
        let realSection = section-1
        return sections[realSection].count
    
      }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count+1
    }
    
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimerCell", for: indexPath) as! TimerCell
            cell.setup(with: self.event)
            return cell
    
        }
        
        let realSection = indexPath.section-1
        
        let pair = sections[realSection][indexPath.row]
        
        if pair.type == .nextOccurence {
            
            let id = "StackedEventInfoItemCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! StackedInfoItemCell
            cell.setup(type: pair.title, info: pair.info)
            return cell
            
        } else {
            
           let id = "InfoItemCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! InfoItemCell
            cell.setup(type: pair.title, info: pair.info)
            return cell
            
        }
        
        
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = getInfoItemFor(indexPath: indexPath), item.type == .nextOccurence, let next = event.followingOccurence {
            
            let infoView = EventInfoViewGenerator.shared.generateEventInfoView(for: next, isFollowingOccurence: true)
    
            if let navigationController = self.navigationController {
                navigationController.pushViewController(infoView, animated: true)
            } else {
                infoView.modalPresentationStyle = .pageSheet
                self.present(infoView, animated: true, completion: nil)
            }
            
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func getInfoItemFor(indexPath: IndexPath) -> HLLEventInfoItem? {
        
        let realSection = indexPath.section-1
        if sections.indices.contains(realSection) {
            
            let section = sections[realSection]
            
            if section.indices.contains(indexPath.row) {
                
                return section[indexPath.row]
                
            }
            
        }
        
        return nil
        
    }
    
    @objc func presentEventMenu() {
    
        let alertController = HLLEventActionSheetGenerator.shared.generateActionSheet(for: self.event, isFollowingOccurence: self.isFollowingOccurence)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

@available(iOS 13.0, *)
extension EventInfoViewController {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let realSection = indexPath.section-1
        
        if let followingOccurence = self.event.followingOccurence, sections.indices.contains(realSection), sections[realSection].indices.contains(indexPath.row), sections[realSection][indexPath.row].type == .nextOccurence {

           
            let config = UIContextMenuConfiguration(identifier: NSString("FollowingOccurence"),
                                              previewProvider: {
                                                
                                                
                                                return EventInfoViewGenerator.shared.generateEventInfoView(for: followingOccurence, isFollowingOccurence: true)
                                                
            },
                                                actionProvider: { _ in
                                                return HLLEventContextMenuGenerator.shared.generateContextMenuForEvent(followingOccurence, isFollowingOccurence: true)  })
            
        return config
            
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        if configuration.identifier as? String == "FollowingOccurence" {
        
        animator.addCompletion {
            
            if let followingOccurence = self.event.followingOccurence {
            
             
                let viewController = EventInfoViewGenerator.shared.generateEventInfoView(for: followingOccurence, isFollowingOccurence: true)
                
                self.navigationController?.pushViewController(viewController, animated: true)

                
            }
            
            }
            
        }
        
    }
    
}

protocol EventInfoItemCell {
    func setUp(infoType: String, infoString: String)
}
