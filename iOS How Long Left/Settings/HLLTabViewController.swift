//
//  HLLTabViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 27/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit
import SwiftUI

class HLLTabViewController: UITabBarController, UITabBarControllerDelegate {

    let cd = CountdownsViewController()
    let up = UpcomingViewController()
    let settings = HLLSettingsTableViewController(style: .insetGrouped)
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .systemOrange
        self.tabBar.tintColor = .orange
        //self.tabBar.isHidden = self.traitCollection.horizontalSizeClass == .regular
        self.delegate = self
        
        let appearance = tabBar.standardAppearance
        appearance.configureWithDefaultBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       super.viewWillAppear(animated)
        self.cd.tabBarItem = UITabBarItem(title: "Countdowns", image: UIImage(systemName: "hourglass"), selectedImage: UIImage(systemName: "hourglass"))
        self.up.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(systemName: "calendar.day.timeline.trailing"), selectedImage: UIImage(systemName: "calendar.day.timeline.trailing"))
        self.settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        
        self.view.backgroundColor = .systemGroupedBackground
        self.viewControllers = [setupInNavigationController(cd), setupInNavigationController(up), setupInNavigationController(settings)]
        
        currentIndex = self.selectedIndex
    }
    
    func setupInNavigationController(_ vc: UIViewController) -> UINavigationController {
        
        let navController = HLLNavigationController(rootViewController: vc)
        navController.navigationBar.tintColor = .systemOrange
        return navController
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if UIDevice.current.userInterfaceIdiom != .phone {
           // self.tabBar.isHidden = self.traitCollection.horizontalSizeClass != .compact && self.splitViewController!.isCollapsed
            
        }
        
       
        
        #if targetEnvironment(macCatalyst)
        self.tabBar.isHidden = true
        #endif
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("Getting dif")
        
        if let windowWidth = self.view.window?.frame.width {
            
            let dif = windowWidth - self.view.frame.width
            
            print("Dif is \(dif)")
            
            if dif == 0   {
                self.tabBar.isHidden = false
            } else {
                self.tabBar.isHidden = true
            }
    
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let newIndex = Int(self.viewControllers!.firstIndex(of: viewController)!)
        return shouldSelect(newIndex: newIndex)
        
        
    }
    
   
    func shouldSelect(newIndex: Int) -> Bool {
       
        
        let selectedTab =  HLLAppTab(rawValue: newIndex)!
        
        (self.splitViewController as! HLLSplitViewController).sidebarController.switchToTab(selectedTab)
        
        if newIndex == self.currentIndex {
            DispatchQueue.main.async {
                self.scrollToTopFor(index: newIndex)
            }
            self.currentIndex = newIndex
            return false
            
        }
        
        self.currentIndex = newIndex
        return true
        
        
    }
    
    func scrollToTopFor(index: Int) {
        
       
        
        guard let vc = (self.viewControllers?[index].children.first! as? ScrollUpDelegate) else { return }
        vc.scrollUp()
        
        
    }
    
    
    
    
    func switchToTab(_ tab: HLLAppTab) {
        
        self.selectedIndex = tab.rawValue
        
    }
    
    
    
    

}
