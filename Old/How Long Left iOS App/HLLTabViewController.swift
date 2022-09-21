//
//  HLLTabViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 27/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class HLLTabViewController: UITabBarController, UITabBarControllerDelegate {

    let cd = CountdownsViewController()
    let up = UpcomingViewController()
    let settings = HLLSettingsTableViewController(style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .systemOrange
        self.tabBar.tintColor = .orange
        self.tabBar.isHidden = self.traitCollection.horizontalSizeClass == .regular
        self.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       super.viewWillAppear(animated)
        self.cd.tabBarItem = UITabBarItem(title: "Current", image: UIImage(systemName: "hourglass"), selectedImage: UIImage(systemName: "hourglass"))
        self.up.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(systemName: "calendar.day.timeline.trailing"), selectedImage: UIImage(systemName: "calendar.day.timeline.trailing"))
        self.settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        self.view.backgroundColor = .systemGroupedBackground
        self.viewControllers = [setupInNavigationController(cd), setupInNavigationController(up), setupInNavigationController(settings)]
        
    }
    
    func setupInNavigationController(_ vc: UIViewController) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.tintColor = .systemOrange
        return navController
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if UIDevice.current.userInterfaceIdiom != .phone {
            self.tabBar.isHidden = self.traitCollection.horizontalSizeClass != .compact && self.splitViewController!.isCollapsed
            
        }
        
        #if targetEnvironment(macCatalyst)
        self.tabBar.isHidden = true
        #endif
        
        
    }
    
    func switchToTab(_ tab: HLLAppTab) {
        
        self.selectedIndex = tab.rawValue
        
    }
    
    
    
    

}
