//
//  HLLWCManager.swift
//  How Long Left
//
//  Created by Ryan Kontos on 27/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import WatchConnectivity

class HLLWCManager: NSObject, WCSessionDelegate {
    
    // Monitor WCSession activation state changes.
    //
    
    override init() {
        super.init()
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // print("WCSession activation is now \(session.activationState)")
        if let error = error { // print("Error activating WCSession: \(error)")
            
        }
    }
    
    
    
    // Monitor WCSession reachability state changes.
    //
    func sessionReachabilityDidChange(_ session: WCSession) {
        // print("WCSession reachability is now \(session.isReachable)")
    }
    
    // Did receive an app context.
    //
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        HLLWCDataReceiver.shared.handleApplicationContext(context: applicationContext)
    }
    
    // Did receive a message, and the peer doesn't need a response.
    //
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        HLLWCDataReceiver.shared.handleMessage(message: message)
    }
    
    // Did receive a message, and the peer needs a response.
    //
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        HLLWCDataReceiver.shared.handleMessage(message: message)
    }
    
    // Did receive a piece of userInfo.
    //
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        HLLWCDataReceiver.shared.handleUserInfo(userInfo: userInfo)
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        
        
    }
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        
    }
    
    // Did finish sending a piece of userInfo.
    //
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
     
        if let error = error {
            // print("Failed to send userInfo: \(error)")
        } else {
            // print("UserInfo transfer complete!")
        }
        
    }

    // WCSessionDelegate methods for iOS only.
    //
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        // print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        // print("Session deactivated, reactivating!")
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        // print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    #endif

}
