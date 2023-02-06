//
//  LaunchFunctions.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 9/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class LaunchFunctions: EventSourceUpdateObserver, OnboardingCompletionDelegate {
    
    static var shared = LaunchFunctions()
    

    
    var performedPostOnboardingActions = false
    
    func runLaunchFunctions() {
        
      //  HLLDefaults.defaults.set(nil, forKey: "HSCSubjects")
        
        //SubjectSelectionWindowManager.shared.showSubjectSelection()
        
        HLLDefaults.notifications.milestones.removeAll(where: {$0 == 0})
        
        
        if Version.launchType == .firstLaunchEver {
            
             OnboardingWindowManager.shared.showOnboardingIfNeeded(delegate: self)
           
            
        } else {
            
           
            onboardingComplete()
            
           
            
        }
        
    }
    
    func onboardingComplete() {
        
      //  HLLDefaults.appData.launchedVersion = Version.currentVersion
        HLLEventSource.shared.addeventsObserver(self)
        ProOnboardingWindowManager.shared.onboardingComplete()
        
        
    }
    
    func eventsUpdated() {
        
        if performedPostOnboardingActions == false {
            
            performedPostOnboardingActions = true
            postOnboardingLaunchActions()
            
            
         
        }
        
    }
    
    func postOnboardingLaunchActions() {
      
 
        
    }
    
}
