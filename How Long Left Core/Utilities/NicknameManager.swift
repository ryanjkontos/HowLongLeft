//
//  NicknameManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 25/8/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import CoreData

class NicknameManager: ObservableObject {
    
    static var shared = NicknameManager()
    
    var entities = [NicknameEntity]()
    
    var nicknameObjects: [NicknameObject] {
        
        return entities.map({ NicknameObject($0.originalName ?? "", nickname: $0.nickname, compactNickname: nil) })
        
    }
    
    init() {
        
     
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        
        loadNicknames()
        
    }
    
    func loadNicknames() {
      
        let oldNicknameObjects = nicknameObjects
        
       var returnArray = [NicknameEntity]()
               
        let managedContext = HLLDataModel.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NicknameEntity> = NicknameEntity.fetchRequest()
        if let items = try? managedContext.fetch(fetchRequest) {
            returnArray = items
        }
        
        self.entities = returnArray
        
     
        
        DispatchQueue.main.async {
            
            if self.nicknameObjects != oldNicknameObjects {
                HLLEventSource.shared.asyncUpdateEventPool()
            }
            
            self.objectWillChange.send()
        }
        
        
    }
    
    func addNicknames(for events: [HLLEvent]) -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
        for event in events {
            
            if let nicknameData = entities.first(where: { $0.originalName == event.originalTitle }), let nickname = nicknameData.nickname {
                
                var nicknamed = event
                nicknamed.title = nickname
                nicknamed.isNicknamed = true
                returnArray.append(nicknamed)
                
            } else {
                returnArray.append(event)
            }
      
        }
        
        return returnArray
        
    }
    
    func isNicknamed(event: HLLEvent) -> Bool {
        self.entities.contains(where: { $0.originalName == event.originalTitle })
    }
    
    func setNickname(_ nickname: String?, compactNickname: String? = nil ,for event: HLLEvent) {
        
        let object = NicknameObject(event.originalTitle, nickname: nickname, compactNickname: compactNickname)
        saveNicknameObject(object)
        
        loadNicknames()
    }
    
    func saveNicknameObject(_ object: NicknameObject) {
        
        DispatchQueue.main.async {
            
            if let existing = self.entities.first(where: { $0.originalName == object.originalName }) {
                existing.nickname = object.nickname
            } else {
                let entity = NSEntityDescription.insertNewObject(forEntityName: "NicknameEntity", into: HLLDataModel.shared.persistentContainer.viewContext) as! NicknameEntity
                entity.originalName = object.originalName
                entity.nickname = object.nickname
            }
            
            HLLDataModel.shared.save()
            self.objectWillChange.send()
            
            HLLEventSource.shared.asyncUpdateEventPool()
            
        }
        
        
    }
    

    func deleteNicknameObject(_ object: NicknameObject) {
        
        if let existing = self.entities.first(where: { $0.originalName == object.originalName }) {
            HLLDataModel.shared.persistentContainer.viewContext.delete(existing)
            HLLDataModel.shared.save()
        }
        
    }


    
    @objc func contextSaved() {
        
        DispatchQueue.main.async {
            
            self.loadNicknames()
            HLLEventSource.shared.asyncUpdateEventPool()
            
            
        }
        
    }
    
}

/*class NicknameManager: ObservableObject {
    
    static var shared = NicknameManager()
    
    private var oldDictionaryKey = "Nicknames"
    private var newDictionaryKey = "NicknamesObjects"
    
    private let fullNicknameKey = "Full"
    private let compactNicknameKey = "Compact"
    
    typealias NicknamesDictionary = [ String : [ String : String ]]
   
    @Published var nicknameObjects: [NicknameObject] = []
    
    init() {
        
        migrateFromOldNicknameStorage()
        loadNicknames()
        
    }

    func addNicknames(for events: [HLLEvent]) -> [HLLEvent] {
        
        let nicknames = getNicknameDictionary()
        
        var returnArray = [HLLEvent]()
        
        for event in events {
            
            if let nicknameData = nicknames[event.originalTitle], let nickname = nicknameData[fullNicknameKey] {
                
                var nicknamed = event
                nicknamed.title = nickname
                nicknamed.isNicknamed = true
                returnArray.append(nicknamed)
                
            } else {
                returnArray.append(event)
            }
      
        }
        
        return returnArray
        
    }
    
    func setNickname(_ nickname: String?, compactNickname: String? = nil ,for event: HLLEvent) {
        
        let object = NicknameObject(event.originalTitle, nickname: nickname, compactNickname: compactNickname)
        HLLNicknameStore.shared.saveNicknameObject(object)
        
        loadNicknames()
    }

    func loadNicknames() {
        nicknameObjects = convertNicknamesDictToObjects(getNicknameDictionary())
    }
    
    private func getNicknameDictionary() -> NicknamesDictionary {
        
        var dictionary = [String:[String:String]]()
        
        #if os(macOS)
        
        if ProStatusManager.shared.isPro == false {
            return dictionary
        }
        
        #endif
        
        if let existingDictionary = HLLDefaults.defaults.dictionary(forKey: newDictionaryKey) as? NicknamesDictionary {
            dictionary = existingDictionary
        }
        
        return dictionary
        
    }
    
    func convertNicknamesDictToObjects(_ dict: NicknamesDictionary) -> [NicknameObject] {
        
        var returnArray = [NicknameObject]()
        
        for item in dict {
            returnArray.append(NicknameObject(item.key, nickname: item.value[fullNicknameKey], compactNickname: item.value[compactNicknameKey]))
        }
        
        return returnArray
        
    }
    
    
    func deleteNicknameObject(_ object: NicknameObject) {
        
        var dictionary = getNicknameDictionary()
        dictionary[object.originalName] = nil
        saveNicknameDictionary(dictionary)
        loadNicknames()
        HLLEventSource.shared.asyncUpdateEventPool()
        
    }
    
    func saveNicknameObject(_ object: NicknameObject) {
        
        var dictionary = getNicknameDictionary()
        dictionary[object.originalName] = generateNicknameDict(nickname: object.nickname, compactNickname: object.compactNickname)
        saveNicknameDictionary(dictionary)
        loadNicknames()
        HLLEventSource.shared.asyncUpdateEventPool()
        
    }
    
    private func saveNicknameDictionary(_ dictionary: NicknamesDictionary) {
        HLLDefaults.defaults.set(dictionary, forKey: newDictionaryKey)
    }
    
    func generateNicknameDict(nickname: String?, compactNickname: String?) -> [String:String] {
        
        var dict = [String:String]()
        if let nickname = nickname { dict[fullNicknameKey] = nickname }
        if let compactNickname = compactNickname { dict[compactNicknameKey] = compactNickname }
        return dict
        
    }
    
    func migrateFromOldNicknameStorage() {
        
        guard let existingDictionary = HLLDefaults.defaults.dictionary(forKey: oldDictionaryKey) as? [String:String] else {
            return
        }
        
        var newDict = [String:[String:String]]()
        
        for existingItem in existingDictionary {
            newDict[existingItem.key] = generateNicknameDict(nickname: existingItem.value, compactNickname: nil)
        }
        
        HLLDefaults.defaults.set(newDict, forKey: newDictionaryKey)
       
        HLLDefaults.defaults.set(nil, forKey: oldDictionaryKey)
        
    }
    
} */

class NicknameObject: ObservableObject, Identifiable, Equatable {
    
    internal init(_ originalName: String, nickname: String?, compactNickname: String?) {
        self.originalName = originalName
        self.nickname = nickname
        self.compactNickname = compactNickname
    }
    
    @Published var originalName: String
    
    @Published var nickname: String?
    @Published var compactNickname: String?
    
    static func getObject(for event: HLLEvent) -> NicknameObject {
        
        let store = NicknameManager.shared
        
        if let item = store.nicknameObjects.first(where: { $0.originalName == event.originalTitle }) {
            return item
        }
        
        return NicknameObject(event.originalTitle, nickname: "", compactNickname: nil)
        
    }
    
    static func == (lhs: NicknameObject, rhs: NicknameObject) -> Bool {
        return lhs.originalName == rhs.originalName &&
        lhs.nickname == rhs.nickname
    }
    
  
}
