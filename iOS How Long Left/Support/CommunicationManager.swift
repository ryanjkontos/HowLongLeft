//
//  CommunicationManager.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 1/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import Communicator

class CommunicationManager {
    
    init() { 
        
        ImmediateMessage.observe { message in
          
            print("Got immediate message: \(message)")
            
        }
        
        GuaranteedMessage.observe { message in
          
            print("Got guaranteed message: \(message)")
            
        }
        
        Context.observe { content in
            
            print("Got context: \(content)")
            
        }
        
    }
    
    
}
