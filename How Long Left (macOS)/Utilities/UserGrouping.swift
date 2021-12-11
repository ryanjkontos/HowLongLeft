//
//  UserGrouping.swift
//  How Long Left
//
//  Created by Ryan Kontos on 3/5/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation



class UserGrouping {
    
    static let shared = UserGrouping()
    
    var groupableUsers = [GroupableUser]()
    
    init() {
        
        groupableUsers.append(GroupableUser(computerName: "HarringtonK0", group: .Boiz))
        groupableUsers.append(GroupableUser(computerName: "FullerM0", group: .Boiz))
        groupableUsers.append(GroupableUser(computerName: "KontosR0", group: .Boiz))
        groupableUsers.append(GroupableUser(computerName: "CroweT0", group: .Boiz))
        groupableUsers.append(GroupableUser(computerName: "WhiteS0", group: .BoizGirls))

    }
    
    func getCurrentGroup() -> UserGroup {
        
        if HLLDefaults.defaults.bool(forKey: "beenGay") == true {
            
            return .Gay
            
        }
        
        if let deviceName = Host.current().localizedName {
            
            for user in groupableUsers {
                
                if deviceName.lowercased().contains(text: user.computerName) {
                    
                    if user.group == .Gay {
                        
                        HLLDefaults.defaults.set(true, forKey: "beenGay")
                        
                    }
                    
                   return user.group
                    
                }
                
            }
            
        }
        
        return .None
        
    }
    
    
    
}


class GroupableUser {
    
    var computerName: String
    var group: UserGroup
    
    init(computerName useName: String, group: UserGroup) {
        
        computerName = useName.lowercased()
        self.group = group
        
    }
    
}
