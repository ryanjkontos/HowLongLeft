//
//  watchOS WatchSessionManager.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 25/1/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import EventKit
import ClockKit
import WatchConnectivity
import UserNotifications

class WatchSessionManager: NSObject, WCSessionDelegate {

    let defaults = HLLDefaults.defaults
    let complication = CLKComplicationServer.sharedInstance()
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    

    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    private var dataSourceChangedDelegates = [DataSourceChangedDelegate]()
    
    private let session: WCSession = WCSession.default
    
    func startSession() {
        
        HLLDefaultsTransfer.shared.addTransferHandler(self)
        
        session.delegate = self
        session.activate()
    }

    func addDataSourceChangedDelegate<T>(delegate: T) where T: DataSourceChangedDelegate, T: Equatable {
        dataSourceChangedDelegates.append(delegate)
    }
    
    func removeDataSourceChangedDelegate<T>(delegate: T) where T: DataSourceChangedDelegate, T: Equatable {
        for (index, dataSourceDelegate) in dataSourceChangedDelegates.enumerated() {
            if let dataSourceDelegate = dataSourceDelegate as? T, dataSourceDelegate == delegate {
                dataSourceChangedDelegates.remove(at: index)
                break
            }
        }
    }
}

extension WatchSessionManager {
    
    // Receiver
    
    func sendData(_ data: [String:Any]) {
        
        
        // print("Start8")
            self.session.sendMessage(data, replyHandler: nil, errorHandler: nil)
            self.session.transferUserInfo(data)
        
        do {
        
            try self.session.updateApplicationContext(data)
                
        } catch {
            
           // print("Error updating application context")
            
        }
        
        
    }
    
    func gotData(data: [String : Any]) {
        

        HLLDefaultsTransfer.shared.gotNewPreferences(data)
        
        
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        gotData(data: message)
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        gotData(data: applicationContext)
    }
    
    
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
        gotData(data: userInfo)
    }
}

extension WatchSessionManager: DefaultsTransferHandler {
    
    func transferDefaultsDictionary(_ defaultsToTransfer: [String : Any]) {
        self.sendData(defaultsToTransfer)
    }
    
    
}

protocol DataSourceChangedDelegate {
    func userInfoChanged()
}

