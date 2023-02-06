//
//  HLLDataModel.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 3/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class HLLDataModel {
    
    private var _privatePersistentStore: NSPersistentStore?
    var privatePersistentStore: NSPersistentStore {
        return _privatePersistentStore!
    }

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
    
    lazy var persistentContainer: AppNSPersistentCloudKitContainer = {
        let container = AppNSPersistentCloudKitContainer(name: "HLLDataModel")
        
        
        let privateStoreDescription = container.persistentStoreDescriptions.first!
        let storesURL = privateStoreDescription.url!.deletingLastPathComponent()
        privateStoreDescription.url = storesURL.appendingPathComponent("HLLDataModelLocal.sqlite")
        privateStoreDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        privateStoreDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        //Add Shared Database
       
        
        if true {
            let containerIdentifier = privateStoreDescription.cloudKitContainerOptions!.containerIdentifier
            
            print("Got container ID: \(containerIdentifier)")
            
            let privateStoreOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.ryankontos.howlongleft")
            privateStoreOptions.databaseScope = .private
            privateStoreDescription.cloudKitContainerOptions = privateStoreOptions
        } else {
            privateStoreDescription.cloudKitContainerOptions = nil
        }
        
        //Load the persistent stores.
        
        #if !os(watchOS)
        
        if Bundle.main.bundlePath.hasSuffix(".appex") {
            privateStoreDescription.cloudKitContainerOptions = nil
        }
      
        #endif
        
        container.loadPersistentStores(completionHandler: { (loadedStoreDescription, error) in
            if let loadError = error as NSError? {
                fatalError("###\(#function): Failed to load persistent stores:\(loadError)")
            } else if let cloudKitContainerOptions = loadedStoreDescription.cloudKitContainerOptions {
                if .private == cloudKitContainerOptions.databaseScope {
                    self._privatePersistentStore = container.persistentStoreCoordinator.persistentStore(for: loadedStoreDescription.url!)
                }
            }
            
            self.storeLoaded = true
            HLLEventSource.shared.updateEventsAsync(bypassCollation: true)
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        //container.viewContext.transactionAuthor = appTransactionAuthorName
        
        // Pin the viewContext to the current generation token, and set it to keep itself up to date with local changes.
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
        }
        
        // Observe Core Data remote change notifications.
       /* NotificationCenter.default.addObserver(self,
                                               selector: #selector(storeRemoteChange(_:)),
                                               name: .NSPersistentStoreRemoteChange,
                                               object: container.persistentStoreCoordinator) */
        
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

class AppNSPersistentCloudKitContainer: NSPersistentCloudKitContainer {
    open override func newBackgroundContext() -> NSManagedObjectContext {
        let context = super.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true

        return context
    }

    override func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        super.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            context.automaticallyMergesChangesFromParent = true
            block(context)
        }
    }
}
