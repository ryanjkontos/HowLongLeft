//
//  CountdownsViewController.swift
//  UIKit HLL
//
//  Created by Ryan Kontos on 27/7/2022.
//

import UIKit
import SwiftUI

class CountdownsViewController: UIViewController, EventPoolUpdateObserver {
    
    struct ListSection: Hashable {
        
        var title: String
        var events: [EventItem]
        
        init?(_ title: String, _ events: [EventItem]) {
            
            if events.isEmpty {
                return nil
            }
            
            self.title = title
            self.events = events
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
        
        static func == (lhs: ListSection, rhs: ListSection) -> Bool {
               return lhs.title == rhs.title
        }
        
    }
    
    struct EventItem: Hashable {
        
        var event: HLLEvent
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(event.persistentIdentifier)
        }
        
        static func == (lhs: EventItem, rhs: EventItem) -> Bool {
            return lhs.event.persistentIdentifier == rhs.event.persistentIdentifier
        }
        
    }
    

    
    func eventPoolUpdated() {
        loadEvents()
    }
    

    var currentSections = [ListSection]()
 
    var timer: Timer!
    
    var eventsCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<ListSection, EventItem>!
    var nameFilter: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Countdowns"
        
        EventChangeMonitor.shared.addObserver(self)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        HLLEventSource.shared.addEventPoolObserver(self)
        
        configureHierarchy()
        configureDataSource()
        loadEvents()
        
        updateCountdowns()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCountdowns), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCountdowns()
    }

}

extension CountdownsViewController {
    /// - Tag: MountainsDataSource
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration
        <CountdownCell, EventItem> { (cell, indexPath, event) in
            // Populate the cell with our item description.
            
            
            cell.configureForEvent(event: event.event)
            cell.sub.timerLabel.text = self.getCountdownText(for: event.event, at: Date())
        }
        
       
        
        dataSource = UICollectionViewDiffableDataSource<ListSection, EventItem>(collectionView: eventsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: EventItem) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        let globalHeaderRegistration = UICollectionView.SupplementaryRegistration<CountdownsViewHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { (header, elementKind, indexPath) in
           
            header.text.text = self.currentSections[indexPath.section].title.uppercased()
            
           
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            
            return self.eventsCollectionView.dequeueConfiguredReusableSupplementary(using: globalHeaderRegistration, for: indexPath)
            
        }
    }
    
}

extension CountdownsViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = self.getColumns(from: contentSize.width)
            let spacing = CGFloat(15)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(125))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(spacing)
            
            
            let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                     heightDimension: .absolute(25))
            let section = NSCollectionLayoutSection(group: group)
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerHeaderSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            section.boundarySupplementaryItems = [header]
            
            
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

            return section
        }
        return layout
    }

    func getColumns(from width: CGFloat) -> Int {
        
        print("Get cols from \(width)")
        
        if width < 740 { return 1 }
        
        let v = Double(width/650)
        return Int(v.rounded(.up))
        
    }
    
    func loadEvents() {
        
        let pinned = HLLEventSource.shared.getPinnedEvents().map({  EventItem(event: $0 )})
        
        let events = HLLEventSource.shared.getCurrentEvents().map({  EventItem(event: $0 )})
        
        let upcoming = HLLEventSource.shared.getUpcomingEvents(limit: 1).map({  EventItem(event: $0 )})

        var snapshot = NSDiffableDataSourceSnapshot<ListSection, EventItem>()
        
        var sections = [ListSection]()
        
        if let pinnedSection = ListSection("Pinned", pinned) {
            sections.append(pinnedSection)
        }
        
        
        
        if let currentSection = ListSection("Current", events) {
            sections.append(currentSection)
        } else if let upcomingSection = ListSection("Upcoming", upcoming) {
            sections.append(upcomingSection)
        }
        
        
        
        self.currentSections = sections
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.events, toSection: section)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func updateCountdowns() {
        
        DispatchQueue.main.async {
            
            let date = Date()
            
            for indexPath in self.eventsCollectionView.indexPathsForVisibleItems {
                
                let event = self.currentSections[indexPath.section].events[indexPath.row]
                
                if let cell = self.eventsCollectionView.cellForItem(at: indexPath) as? CountdownCell {
                    cell.sub.timerLabel.text = self.getCountdownText(for: event.event, at: date)
                    cell.sub.statusLabel.text = "\(event.event.countdownTypeString())"
                }
                
            }
            
        }
        
        
        
    }
    
    func getCountdownText(for event: HLLEvent, at date: Date) -> String {
        CountdownStringGenerator.shared.generatePositionalCountdown(event: event, at: date, showSeconds: HLLDefaults.countdownsTab.showSeconds)
    }
    
    func configureHierarchy() {
        view.backgroundColor = .systemBackground
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        //collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        
        view.addSubview(collectionView)
        
       
        
        eventsCollectionView = collectionView

       
    }
    
}

extension CountdownsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let event = HLLEventSource.shared.eventPool[indexPath.row]
        
        if UIApplication.shared.supportsMultipleScenes {
            
            let requestingScene = self.view.window!.windowScene
            
            if let cell = self.eventsCollectionView.cellForItem(at: indexPath) as? CountdownCell {
                EventSceneDelegate.openEventSceneSessionForEvent(cell.event, requestingScene: requestingScene!, errorHandler: nil)
            }
            
            
        } else {
            
            let controller = EventInfoTableViewController(style: .insetGrouped).rootedInNavigationController()
            self.present(controller, animated: true)
            
        }

       
        
        
     
       
        
        
        
    }
    

    
}

extension CountdownsViewController: EventChangeObserver {
    
    func eventsChanged() {
        
        loadEvents()
        
    }
    
}
