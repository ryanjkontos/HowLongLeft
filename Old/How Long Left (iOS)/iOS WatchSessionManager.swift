//
//  iOS WatchSessionManager.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 25/1/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import WatchConnectivity
import EventKit

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    let defaults = HLLDefaults.defaults
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        
    }
        
    func sessionDidDeactivate(_ session: WCSession) {
        WatchSessionManager.sharedManager.startSession()
        
    }
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }

        
    }
    
    
    func watchSupported() -> Bool {
        
        return WCSession.isSupported()
        
    }
    
    var transfers = [WCSessionUserInfoTransfer]()
    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    public var validSession: WCSession? {
        
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    
    func startSession() {
        
        HLLDefaultsTransfer.shared.addTransferHandler(self)
        
        if session?.activationState != WCSessionActivationState.activated {
        
        session?.delegate = self
        session?.activate()
            
            HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
            
            
        }
    }

    
    func userHasAppleWatch() -> Bool {
        
        startSession()
        
        if let session = session, session.isPaired == true {
            return true
        } else {
            return false
        }
        
    }
    
}

extension WatchSessionManager {
    
    // Receiver
    
    func gotData(data: [String : Any]) {
           
        HLLDefaultsTransfer.shared.gotNewPreferences(data)
        
           
    }
    
    func sendData(_ data: [String:Any]) {
        
        if let unwrappedSession = validSession {
            
            for transfer in unwrappedSession.outstandingFileTransfers {
                
                transfer.cancel()
                
            }
            
            for transfer in unwrappedSession.outstandingUserInfoTransfers {
                
                transfer.cancel()
                
            }
            
            
        }
        
        
        
        print("Sendd")
            print("Start3")
            self.validSession?.sendMessage(data, replyHandler: nil, errorHandler: nil)
            self.validSession?.transferUserInfo(data)
        
        do {
        
            try self.validSession?.updateApplicationContext(data)
                
        } catch {
            
           print("Error updating application context")
            
        }
        
        
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
