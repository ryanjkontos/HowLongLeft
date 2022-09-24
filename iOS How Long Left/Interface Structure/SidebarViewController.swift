//
//  SidebarViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 29/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class SidebarViewController: UIViewController {
    
    // MARK: - Structs and sample data

    struct Item: Hashable {
        let title: String?
        let image: UIImage?
        private let identifier = UUID()
    }





    enum Section: String {
        case tabs
    }

    
    var tabController: UITabBarController!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    private var collectionView: UICollectionView! = nil
    
    let tabItems = HLLAppTab.allCases
        .map({ Item(title: $0.tabName(), image: UIImage(systemName: $0.imageName()))})

    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        navigationItem.title = "How Long Left"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .systemOrange
        configureHierarchy()
        configureDataSource()
        addNavigationButtons()
        setInitialSecondaryView()
    }

    private func setInitialSecondaryView() {
        collectionView.selectItem(at: IndexPath(row: 0, section: 0),
                                  animated: false,
                                  scrollPosition: UICollectionView.ScrollPosition.centeredVertically)
        splitViewController?.setViewController(tabController, for: .secondary)
    }

    private func addNavigationButtons() {
        
        
       // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
    }
    
   


}

// MARK: - Layout

extension SidebarViewController {

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .sidebar)
            config.headerMode = section == 0 ? .none : .firstItemInSection
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }

}

// MARK: - Data

extension SidebarViewController {

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        // Configuring cells

        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure()]
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            cell.tintColor = .systemOrange
            content.text = item.title
            content.image = item.image
            cell.contentConfiguration = content
            cell.accessories = []
        }

        // Creating the datasource

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            if indexPath.item == 0 && indexPath.section != 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        }

        // Creating and applying snapshots

        let sections: [Section] = [.tabs,]
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        snapshot.appendItems(tabItems, toSection: .tabs)
        dataSource.apply(snapshot, animatingDifferences: false)

     
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        guard let idx = (tabController as? HLLTabViewController)?.selectedIndex else { return }
        let indexPath = IndexPath(row: idx, section: 0)
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
    }
    
    
    func switchToTab(_ tab: HLLAppTab) {
        
      
        
        let indexPath = IndexPath(row: tab.rawValue, section: 0)
        self.collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        
    }
    
}

// MARK: - UICollectionViewDelegate

extension SidebarViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        
        (tabController as? HLLTabViewController)?.switchToTab(HLLAppTab(rawValue: indexPath.row)!)
        
        //splitViewController?.setViewController(secondaryViewControllers[indexPath.row], for: .secondary)
    }

}

