//
//  UpcomingViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 27/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit
import SwiftUI

class UpcomingViewController: UIViewController, EventPoolUpdateObserver {
    
    func eventPoolUpdated() {
        loadEvents()
    }
    

    var data = [DateOfEvents]()
    
    var eventsCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<DateOfEvents, HLLEvent>!
    var nameFilter: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Upcoming"
        
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        HLLEventSource.shared.addEventPoolObserver(self)
        
        configureHierarchy()
        configureDataSource()
        loadEvents()
        
    }

}

extension UpcomingViewController {
    /// - Tag: MountainsDataSource
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration
        <UpcomingCell, HLLEvent> { (cell, indexPath, event) in
            // Populate the cell with our item description.
            
            cell.configureForEvent(event: event)
        }
        
        
        let globalHeaderRegistration = UICollectionView.SupplementaryRegistration<UpcomingViewHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { (header, elementKind, indexPath) in
            // Opportunity to further configure the header
           
            header.update(for: self.data[indexPath.section].date)
            
        }
        
    
        
        dataSource = UICollectionViewDiffableDataSource<DateOfEvents, HLLEvent>(collectionView: eventsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: HLLEvent) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            
            return self.eventsCollectionView.dequeueConfiguredReusableSupplementary(using: globalHeaderRegistration, for: indexPath)
            
        }
        
    }
    
}

extension UpcomingViewController {
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
                                                   heightDimension: .absolute(50))
            
            
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(spacing)
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 9
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

            let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                     heightDimension: .absolute(60))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerHeaderSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            //header.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
       
        return layout
    }

    func getColumns(from width: CGFloat) -> Int {
        
        print("Get cols from \(width)")
        
        if width < 740 { return 1 }
        
        let v = Double(width/500)
        return Int(v.rounded(.up))
        
    }
    
    func loadEvents() {
        
        let start = Date().startOfDay()
        let end = start.addDays(100)
        
        data = HLLEventSource.shared.getArraysOfUpcomingEventsForDates(startDate: start, endDate: end, returnEmptyItems: false)
        
        
        var snapshot = NSDiffableDataSourceSnapshot<DateOfEvents, HLLEvent>()
        snapshot.appendSections(data)
        
        for dateOf in data {
            snapshot.appendItems(dateOf.events, toSection: dateOf)
        }
        
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureHierarchy() {
        
        
        view.backgroundColor = .systemBackground
        let layout = createLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        //collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        
        eventsCollectionView = collectionView

       
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
       
    }
    
   
}

extension UpcomingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = HLLEventSource.shared.eventPool[indexPath.row]
        
     //   self.present(UIHostingController(rootView: NavigationView { EventView(event: event)}), animated: true)
        

    }
    

    
}
