//
//  HLLDataModel.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 3/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import CoreData

class HLLDataModel {
    
    static var shared: HLLDataModel!
    
    var storeLoaded = false
    
    init() {
           
        
        HLLDataModel.migrate()
           
     
       

       
    }
    
    static var databaseName = "HLLDataModel"
    
     static var model = NSManagedObjectModel(contentsOf: Bundle.main.url(forResource: "HLLDataModel", withExtension: "momd")!)!
    
    static var oldPersistentContainer: NSPersistentContainer = {
        
        
        let container = NSPersistentContainer(name: "HLLDataModel", managedObjectModel: model)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
         //   // print("Store description: \(storeDescription)")
            
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        
        return container
        
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentCloudKitContainer(name: "HLLDataModel")
        // Change this variable instead of creating a new NSPersistentStoreDescription object
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("No Descriptions found")
        }

       // let cloudStoreUrl = applicationDocumentDirectory()!.appendingPathComponent("HLLDataModel.sqlite")

        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSObject, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        description.url = URL.storeURL(for: GroupURL.current, databaseName: HLLDataModel.databaseName)

        description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
                containerIdentifier: "iCloud.ryankontos.howlongleft")
        container.persistentStoreDescriptions = [description]
    
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            
            if let error = error as NSError? {
                // print("Error loading store. \(error)")
            }
            
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
                    containerIdentifier: "iCloud.ryankontos.howlongleft")
            
            DispatchQueue.main.async {
                
                //self.storeLoaded = true
               // HLLEventSource.shared.updateEventsAsync()
                
            }
            
        })

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true

        try? container.viewContext.setQueryGenerationFrom(.current)
        //container.viewContext.transactionAuthor = transactionAuthorName
        
        return container
        
    }()
    
    
    class func migrate() {
        
        if Bundle.main.bundlePath.hasSuffix(".appex") {
            return
        }

        
        if HLLDefaults.appData.migratedCoreData {
            return
        }
       
        let coordinator = oldPersistentContainer.persistentStoreCoordinator
        
        if let oldStore = coordinator.persistentStores.first {
        
        let newStoreURL = URL.storeURL(for: GroupURL.current, databaseName: HLLDataModel.databaseName)
        
        do {
          try coordinator.migratePersistentStore(oldStore, to: newStoreURL, options: nil, withType: NSSQLiteStoreType)
        } catch {
          // Handle error
        }
        
            // print("Old store was located at: \(oldStore.url!)")
            
        do {
            try coordinator.destroyPersistentStore(at: oldStore.url!, ofType: "HLLDataModel", options: nil)
        } catch {
          // print("Error destroying old store: \(error)")
        }
        
            HLLDefaults.appData.migratedCoreData = true
        
    }
        
    }
    

    func save() {
        
        DispatchQueue.main.async {
            try! HLLDataModel.shared.persistentContainer.viewContext.save()
        }
        
        
        
    }
    
    
}


public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
