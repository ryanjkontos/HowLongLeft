//
//  Editions.swift
//  How Long Left
//
//  Created by Ryan Kontos on 3/5/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation

class Edition {
    
    static let shared = Edition()
    
    var editionedUsers = [Person]()
    
    init() {
        
        editionedUsers.append(Person(computerName: "HarringtonK0", edition: .Boiz))
        editionedUsers.append(Person(computerName: "FullerM0", edition: .Boiz))
        editionedUsers.append(Person(computerName: "RichardsH0", edition: .Boiz))
        editionedUsers.append(Person(computerName: "KontosR0", edition: .Boiz))
        editionedUsers.append(Person(computerName: "CroweT0", edition: .Boiz))
        //editionedUsers.append(Person(computerName: "NiesJ0", edition: .Gay))
        
    }
    
    func getCurrentEdition() -> Editions {
        
        if HLLDefaults.defaults.bool(forKey: "beenGay") == true {
            
            return .Gay
            
        }
        
        if let deviceName = Host.current().localizedName {
            
            for user in editionedUsers {
                
                if deviceName.lowercased().contains(text: user.computerName) {
                    
                    if user.edition == .Gay {
                        
                        HLLDefaults.defaults.set(true, forKey: "beenGay")
                        
                    }
                    
                   return user.edition
                    
                }
                
            }
            
        }
        
        return .None
        
    }
    
    
    
}


class Person {
    
    var computerName: String
    var edition: Editions
    
    init(computerName useName: String, edition useEdition: Editions) {
        
        computerName = useName.lowercased()
        edition = useEdition
        
    }
    
}
