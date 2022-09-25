//
//  CountdownsViewController.swift
//  UIKit HLL
//
//  Created by Ryan Kontos on 27/7/2022.
//

import UIKit
import SwiftUI

class CountdownsViewController: UIViewController, EventPoolUpdateObserver {
    
    var lastResizeID = UUID()
    var resizing = false
    
    var noDataLabel = UILabel()
    
    var collectionView: UICollectionView!
    
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
        DispatchQueue.main.async {
            self.loadEvents()
        }
        
    }
    

    var currentSections = [ListSection]()
 
    var timer: Timer!
    
    var eventsCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<ListSection, EventItem>!
    var nameFilter: String?

    var lastUpdateTime: String?
    var previousPaths = [IndexPath]()
    
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
        setupBackground()
        loadEvents()
        
        updateCountdowns()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEvents()
        updateCountdowns()
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCountdowns), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidLayoutSubviews() {
        
        resizing = true
        
        let id = UUID()
        self.lastResizeID = id
        
        updateCountdowns(force: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            
            if self.lastResizeID == id {
                
                print("Done Resizing")
                self.resizing = false
                
                self.updateCountdowns(force: true)
                
            }
            
        }
            
    }
    
    
    var biggestTopSafeAreaInset: CGFloat = 0
                
        override func viewSafeAreaInsetsDidChange() {
            super.viewSafeAreaInsetsDidChange()
            self.biggestTopSafeAreaInset = max(self.collectionView.safeAreaInsets.top, biggestTopSafeAreaInset)
        }
}


extension CountdownsViewController {
    /// - Tag: MountainsDataSource
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration
        <CountdownCell, EventItem> { (cell, indexPath, event) in
            // Populate the cell with our item description.
            
            
            cell.configureForEvent(event: event.event)
            cell.sub.updateCountdownLabel()
            cell.menuDelegate = self
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
        
        if width < 730 { return 1 }
        
        let v = Double(width/650)
        return Int(v.rounded(.up))
        
    }
    
    func loadEvents() {
        
        let pinned = HLLEventSource.shared.getPinnedEventsFromEventPool().map({  EventItem(event: $0 )})
        
        
        var events = HLLEventSource.shared.getCurrentEvents().map({  EventItem(event: $0 )})
        
        events.removeAll(where: { pinned.contains($0) })
        
        var upcoming = HLLEventSource.shared.getUpcomingEvents(limit: HLLDefaults.countdownsTab.upcomingCount).map({  EventItem(event: $0 )})

        upcoming.removeAll(where: { pinned.contains($0) })
        
        var snapshot = NSDiffableDataSourceSnapshot<ListSection, EventItem>()
        
        var sections = [ListSection]()
        
        let sectionTypes = HLLDefaults.countdownsTab.sectionOrder
        
        for type in sectionTypes {
            
            switch type {
                
            case .pinned:
                if let pinnedSection = ListSection("Pinned", pinned) {
                    sections.append(pinnedSection)
                }
            case .inProgress:
                if let currentSection = ListSection("In-Progress", events), HLLDefaults.countdownsTab.showInProgress {
                    sections.append(currentSection)
                }
            case .upcoming:
                if let upcomingSection = ListSection("Upcoming", upcoming), HLLDefaults.countdownsTab.showUpcoming {
                    sections.append(upcomingSection)
                }
            }
            
        }
        
    
        self.currentSections = sections
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.events, toSection: section)
        }
        
        noDataLabel.isHidden = !sections.isEmpty
        
        if sections.isEmpty {
            
            (collectionView as UIScrollView).alwaysBounceHorizontal = false
            (collectionView as UIScrollView).showsHorizontalScrollIndicator = false
           
            (collectionView as UIScrollView).alwaysBounceVertical = false
        } else {
            (collectionView as UIScrollView).alwaysBounceVertical = true
        }
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func setupBackground() {
        
        noDataLabel = UILabel(frame: .zero)
        noDataLabel.text = "No Events"
        noDataLabel.textColor = UIColor.secondaryLabel
        noDataLabel.font = UIFont.systemFont(ofSize: 18)
        noDataLabel.textAlignment = .center
        
        self.view.addSubview(noDataLabel)
        
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noDataLabel.widthAnchor.constraint(equalToConstant: 200),
            noDataLabel.heightAnchor.constraint(equalToConstant: 40),
            noDataLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        
    }
    
    @objc func updateCountdowns(force: Bool = false) {
        
        DispatchQueue.main.async {
            
            let currentSections = self.currentSections
            let paths = self.eventsCollectionView.indexPathsForVisibleItems
            
            let date = Date()
                
            let formatter = DateFormatter()
            formatter.timeStyle  = .long
            formatter.dateStyle = .short
            let str = formatter.string(from: date)
                
            
            
            
            if let prevString = self.lastUpdateTime, force == false {
                if str == prevString && paths == self.previousPaths {
                    return
                }
            }
  
            self.previousPaths = paths
            self.lastUpdateTime = str
         
                for indexPath in paths  {
                    
                   
                    
                    if let cell = self.eventsCollectionView.cellForItem(at: indexPath) as? CountdownCell {
                        
                        
                        if self.resizing {
                   
                            cell.sub.removeLabels()
                            
                        } else {
                            if cell.sub.timerLabel == nil {
                                
                                
                                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                                    cell.sub.configure()
                                }
                                
                            }
                            cell.sub.updateCountdownLabel()
                        }
                        
                        
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        //collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        
        view.addSubview(collectionView)
        

        (collectionView as UIScrollView).delegate = self
        
        eventsCollectionView = collectionView
        

       
    }
    
}

extension CountdownsViewController: UICollectionViewDelegate, UIScrollViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let event = currentSections[indexPath.section].events[indexPath.row].event
    
        let controller = EventTableViewController(style: .insetGrouped)
    
        controller.event = event
        
        self.navigationController?.pushViewController(controller, animated: true)
     
       
        
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.resizing = true
        self.updateCountdowns(force: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.resizing = false
        self.updateCountdowns(force: true)
    }
    
 

    
}

extension CountdownsViewController: EventChangeObserver {
    
    func eventsChanged() {
        
        DispatchQueue.main.async {
            
            self.loadEvents()
            
        }
        
    }
    
}

extension CountdownsViewController: EventContextMenuDelegate {
    func closeEventView(event: HLLEvent) {
        return
    }
    
    
    func nicknameEvent(event: HLLEvent) {
        let object = NicknameObject.getObject(for: event)
        let vc = NicknameEditorTableViewController(style: .insetGrouped)
        vc.object = object
        self.present(HLLNavigationController(rootViewController: vc), animated: true)
    }
    
    
   
}

extension CountdownsViewController: ScrollUpDelegate {
    
    
    func scrollUp() {
        
        if let c = self.navigationController?.viewControllers.count, c > 1 {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        let offset = CGPoint(
                x: -collectionView.adjustedContentInset.left,
                y: -collectionView.adjustedContentInset.top)
        
        collectionView.setContentOffset(offset, animated: true)
    }
    
 
}
