//
//  HLLCloudKitPreferences.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 30/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

/*
import Foundation
import CloudKit

class HLLCloudKitPreferences {
    
    static var shared = HLLCloudKitPreferences()
    
    let container = CKContainer(identifier: "iCloud.HLLUserPreferences")
    let recordID = CKRecord.ID(recordName: "HLLUserPreferencesRecordID")
    let recordType = "UserPreferences"
    
    func saveRecord() {
          
        if HLLDefaults.defaults.bool(forKey: "DisabledCloudSync") {
            return
            
        }
        
        
       // // print("Making record for enabled calendars: \(HLLDefaults.calendar.enabledCalendars.count)")
        
        let record = CKRecord(recordType: recordType, recordID: recordID)
        record["EnabledCalendars"] = HLLDefaults.calendar.enabledCalendars as CKRecordValue
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: [])
        operation.savePolicy = .allKeys
        operation.perRecordCompletionBlock = { (record, error) in
            
            if let _ = error {
                
              //  // print("Error saving record: \(existingError)")
                
                
                
            } else {
                
               // // print("No error saving record")
                
            }
            
        }
        
        let config = CKOperation.Configuration()
        config.isLongLived = true
        
        operation.configuration = config
        operation.queuePriority = .high
        operation.qualityOfService = .utility
        container.privateCloudDatabase.add(operation)
        
        
    }
    
    func getRecord() {
        
        if HLLDefaults.defaults.bool(forKey: "DisabledCloudSync") {
            return
            
        }
        
        let previousCalendars = HLLDefaults.calendar.enabledCalendars
        
        let operation = CKFetchRecordsOperation(recordIDs: [recordID])
        operation.perRecordCompletionBlock = { (record, id, error) in
            
            if let _ = error as? CKError {
                
               // // print("Error getting record: \(existingError)")
                
                
                
                return
                
            }
            
            if let existingRecord = record, let calendarArray = existingRecord["EnabledCalendars"] as? [String] {
                
              //  // print("Fetched record: \(calendarArray)")
                
                if calendarArray != previousCalendars {
                    
                    HLLDefaults.calendar.enabledCalendars = calendarArray
                    HLLEventSource.shared.updateEvents()
                    // print("PoolC1")
                    
                }
                
            } else {
                
              //  // print("Error in record unwrapping post error check")
                
            }
            
            
            
        }
        operation.queuePriority = .high
        operation.qualityOfService = .utility
        container.privateCloudDatabase.add(operation)
        
    }
    
    func subscribe() {
        
        if HLLDefaults.defaults.bool(forKey: "createdSubscription") { return }
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        
        let subscription = CKQuerySubscription(recordType: recordType, predicate: NSPredicate(value: true), subscriptionID: String(NSUUID().uuidString), options: [CKQuerySubscription.Options.firesOnRecordUpdate, .firesOnRecordCreation, .firesOnRecordDeletion])
        subscription.notificationInfo = notificationInfo
        
        let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription], subscriptionIDsToDelete: nil)
        operation.modifySubscriptionsCompletionBlock = { (subscription, id, error) in
            
            if let _ = error {
                
               // // print("Error saving subscription: \(existingError)")
                
            } else {
                
               // // print("Successfully saved subscription")
                HLLDefaults.defaults.set(true, forKey: "createdSubscription")
                
            }
            
            
        }
        
        operation.qualityOfService = .utility
        container.privateCloudDatabase.add(operation)
    }
    
    func handleRemoteUserInfo(_ userInfo: [AnyHashable : Any]) {
        
     //   // print("Got remote notification")
        
        if let noto = CKNotification(fromRemoteNotificationDictionary: userInfo) {
            
            //// print("Unwrapped remote notification")
            
            if noto.containerIdentifier == HLLCloudKitPreferences.shared.container.containerIdentifier {
                
               // // print("Ids matched for notification")
                getRecord()
                
            }
            
        }

        
    }
    
    
}
*/
