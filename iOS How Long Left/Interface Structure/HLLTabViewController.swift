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
    
    let floatingTabbarView = FloatingBarView(["hourglass", "calendar.day.timeline.trailing", "gearshape.fill"])
    
    var currentIndex = 0
    
    let notifView = UIView()
    let notifText = UILabel()
    var notifImageView = UIImageView()
    
    override func viewDidLoad() {
        self.tabBar.itemSpacing = 5

        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .systemOrange
        self.tabBar.tintColor = .orange
        //self.tabBar.isHidden = self.traitCollection.horizontalSizeClass == .regular
        self.delegate = self
        
        let appearance = tabBar.standardAppearance
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .secondarySystemGroupedBackground
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -4)
        tabBar.layer.shadowRadius = 7
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.07
        
        createNotifView()
        notifView.alpha = 0
      
        
    }

   
    


    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
       super.viewWillAppear(animated)
        
        self.cd.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "hourglass"), selectedImage: UIImage(systemName: "hourglass"))
        self.up.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "calendar.day.timeline.trailing"), selectedImage: UIImage(systemName: "calendar.day.timeline.trailing"))
        self.settings.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "gearshape.fill"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        self.cd.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0);
        self.up.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0);
        self.settings.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0);
        
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
        // print("Getting dif")
        
        if let windowWidth = self.view.window?.frame.width {
            
            let dif = windowWidth - self.view.frame.width
            
            // print("Dif is \(dif)")
            
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
        
        (self.splitViewController as! HLLRootViewController).sidebarController.switchToTab(selectedTab)
        
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
    
    
    
    
    func createNotifView() {
        
        
        notifView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(notifView)
        
        notifView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            //notifView.widthAnchor.constraint(equalToConstant: 150),
            notifView.heightAnchor.constraint(equalToConstant: 50),
            notifView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notifView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -20),
        ])
        
        // Create a visual effect view with a blur and vibrancy effect
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
        let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .regular)))
        visualEffectView.contentView.addSubview(vibrancyView)

        // Add the visual effect view as a subview of your notifView
        notifView.addSubview(visualEffectView)

        // Set the autoresizing masks for the visual effect view
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: notifView.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: notifView.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: notifView.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: notifView.bottomAnchor),
            vibrancyView.topAnchor.constraint(equalTo: visualEffectView.contentView.topAnchor),
            vibrancyView.leadingAnchor.constraint(equalTo: visualEffectView.contentView.leadingAnchor),
            vibrancyView.trailingAnchor.constraint(equalTo: visualEffectView.contentView.trailingAnchor),
            vibrancyView.bottomAnchor.constraint(equalTo: visualEffectView.contentView.bottomAnchor),
        ])

        notifView.layer.masksToBounds = true
        notifView.layer.cornerRadius = 13

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        notifView.addSubview(stackView)

        // Create and add a symbol to the stack view
        let symbol = UIImage(systemName: "pin.fill")
        notifImageView = UIImageView(image: symbol)
        notifImageView.tintColor = .label
        
        
        stackView.addArrangedSubview(notifImageView)
        notifImageView.isHidden = true

        // Create and add a label to the stack view
        let label = notifText
        label.text = "Event Pinned"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left
        stackView.addArrangedSubview(label)

        // Set the autoresizing masks for the stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: notifView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: notifView.centerYAnchor),
            notifView.widthAnchor.constraint(greaterThanOrEqualTo: stackView.widthAnchor, constant: 30),
        ])


        
    }
    

}

extension HLLTabViewController: FloatingBarViewDelegate {
    func did(selectindex: Int) {
        selectedIndex = selectindex
    }
}
